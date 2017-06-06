-- MIT License
-- 
-- Copyright (c) 2017 Wende Tan, Liu Minghua
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.signals.all;

entity bootloader is
    generic
    (
        WORD_WIDTH: integer := 32; -- word width of SRAM
        LOG2_WORD_WIDTH_DIV_8: integer := 2; -- log2(32 / 8)
        RAM_SIZE: integer := 1024 * 1024 * 32 / 8 -- SRAM size (bytes)
    );
    port
    (
        CLK: in std_logic; -- 25MHz
        RST: in std_logic;

        BL_REQ: out RAM_REQ;
        BL_RES: in RAM_RES;

        SD_CS_n: out std_logic; -- SD_NCS, SD_DATA3_CD
        SD_SCLK: out std_logic; -- SD_CLK
        SD_MISO: in std_logic;  -- SD_DOUT, SD_DATA0_DO
        SD_MOSI: out std_logic; -- SD_DIN, SD_CMD

        DONE: out std_logic;
        REJECTED: out std_logic;
        DBG: out std_logic_vector(3 downto 0)
    );
end;

architecture behavioral of bootloader is
    -- timing constants
    constant POWERON_WAIT_CYCLES: integer := 25000; -- 1ms, if CLK = 25M
    constant SPI_WAIT_CYCLES: integer := 1;
    constant DUMMY_CLOCKS: integer := 80;
    constant MAX_RETRY: integer := 16;

    -- data length
    constant CMD_BITS: integer := 48;
    constant R1_BITS: integer := 8;
    constant DWORD_BUFF_BITS: integer := 32;
    constant SECTOR_SIZE: integer := 512;
    constant WORD_SIZE: integer := WORD_WIDTH / 8;

    -- expected responses
    constant R1_NO_ERROR_IDLE: std_logic_vector(7 downto 0) := x"01";
    constant R1_ILLIGAL_CMD_IDLE: std_logic_vector(7 downto 0) := x"05";
    constant R1_NO_ERROR_NO_IDLE: std_logic_vector(7 downto 0) := x"00";

    -- :-)
    type state_t is (st_poweron_wait, st_dummy_clock,
                     st_cmd0_req, st_cmd0_res, st_cmd0_done,
                     st_cmd8_req, st_cmd8_res, st_cmd8_read_r1, st_cmd8_done,
                     st_cmd55_req, st_cmd55_res, st_cmd55_done,
                     st_acmd41_req, st_acmd41_res, st_acmd41_done,
                     st_cmd58_req, st_cmd58_res, st_cmd58_read_r1, st_cmd58_done,
                     st_cmd16_req, st_cmd16_res, st_cmd16_done,
                     st_cmd17_req, st_cmd17_res, st_cmd17_r1,
                     st_cmd17_read_token, st_cmd17_read_data, st_cmd17_read_crc,
                     st_cmd17_write_ram, st_cmd17_write_ram_done, st_cmd17_done,
                     st_wait_spi, st_send_cmd, st_read_wait, st_read_byte, st_read_dword,
                     st_finish_delay,
                     st_reject, st_done);

    signal current_state, wait_return_state, cmd_return_state, ram_return_state: state_t;

    -- wait_counter ranged 0 to max(SPI_WAIT_CYCLES, POWERON_WAIT_CYCLES) - 1
    signal wait_counter: integer range 0 to POWERON_WAIT_CYCLES - 1;
    signal counter: integer range 0 to 255; -- >= max(DUMMY_CLOCKS, CMD_BITS) * 2 - 1
    signal byte_counter: integer range 0 to SECTOR_SIZE - 1;
    signal retry_counter: integer range 0 to MAX_RETRY - 1; -- TODO: retry
    signal sector_counter: integer range 0 to RAM_SIZE / SECTOR_SIZE - 1;

    signal sd_sclk_buff: std_logic;

    -- (request) command and argument
    signal cmd: integer range 0 to 63;
    signal arg: std_logic_vector(31 downto 0);
    signal crc: std_logic_vector(6 downto 0);
    signal packet: std_logic_vector(47 downto 0);
    signal sector_as_arg: std_logic_vector(31 downto 0);
    signal finish_delay: std_logic; -- delay or not after a command

    -- buffers
    signal byte_buff: std_logic_vector(7 downto 0);
    signal dword_buff: std_logic_vector(31 downto 0);
    signal word_buff: std_logic_vector(WORD_WIDTH - 1 downto 0);

    -- SD card properties
    signal is_sdc2, is_sdhc: std_logic;
begin
    SD_SCLK <= sd_sclk_buff;

    packet <= "01" & conv_std_logic_vector(cmd, 6) & arg & crc & "1";

    sector_as_arg_process:
    process(sector_counter, is_sdhc)
    begin
        -- block addressing when SD card is SDHC/SDXC, otherwise, byte addressing.
        -- ref:
        -- SD Specifications Part 1 Physical Layer Simplified Specification
        --     Table 7-3 : Commands and Arguments (small print)
        --     10. SDSC Card (CCS=0) uses byte unit address and 
        --     SDHC and SDXC Cards (CCS=1) use block unit address (512 bytes unit).
        if is_sdhc = '1' then -- block addressing
            sector_as_arg <= conv_std_logic_vector(sector_counter, sector_as_arg'length);
        else -- byte addressing, 512 bytes aligned
            sector_as_arg <= conv_std_logic_vector(sector_counter * SECTOR_SIZE,
                                                   sector_as_arg'length);
        end if;
    end process;
    
    process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= st_poweron_wait;
            wait_counter <= 0;
            counter <= 0;
            sd_sclk_buff <= '0';
            SD_CS_n <= '1';
            SD_MOSI <= '1';
            byte_buff <= x"00";
            dword_buff <= x"00000000";
            DBG <= x"0";
            retry_counter <= 0;
            is_sdc2 <= '0';
            is_sdhc <= '0';
            finish_delay <= '1';
            sector_counter <= 0;
            byte_counter <= 0;
            BL_REQ.DEN <= '0';
            BL_REQ.WE_n <= '1';
            BL_REQ.OE_n <= '1';
            BL_REQ.ADDR <= x"00000";
        else
            if rising_edge(CLK) then
                case current_state is
                    ------------------------------------------------------------------------------
                    -- SD card initialization
                    -- ref:
                    -- SD Specifications Part 1 Physical Layer Simplified Specification
                    --     7.2.1 Mode Selection and Initialization
                    --     Figure 7-2 : SPI Mode Initialization Flow
                    -- 1. wait 1+ ms
                    when st_poweron_wait =>
                        sd_sclk_buff <= '1';
                        if wait_counter = POWERON_WAIT_CYCLES - 1 then
                            current_state <= st_dummy_clock;
                            wait_counter <= 0;
                        else
                            wait_counter <= wait_counter + 1;
                        end if;
                    -- 2. 74+ dummy clocks
                    when st_dummy_clock =>
                        SD_CS_n <= '1';
                        SD_MOSI <= '1';
                        sd_sclk_buff <= not sd_sclk_buff;
                        if counter = DUMMY_CLOCKS * 2 - 1 then
                            wait_return_state <= st_cmd0_req;
                            current_state <= st_wait_spi;
                            counter <= 0;
                        else
                            wait_return_state <= st_dummy_clock;
                            current_state <= st_wait_spi;
                            counter <= counter + 1;
                        end if;
                    -- 3. CMD0 GO_IDLE_STATE
                    when st_cmd0_req =>
                        SD_CS_n <= '0';
                        cmd <= 0;
                        arg <= x"00000000";
                        crc <= "1001010"; -- CRC is needed.
                        cmd_return_state <= st_cmd0_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd0_res =>
                        finish_delay <= '0';
                        cmd_return_state <= st_cmd0_done;
                        current_state <= st_read_wait;
                    when st_cmd0_done =>
                        if byte_buff = R1_NO_ERROR_IDLE then
                            current_state <= st_cmd8_req;
                        else
                            DBG <= x"0";
                            current_state <= st_reject;
                        end if;
                    -- 4. CMD8 SEND_IF_COND
                    when st_cmd8_req =>
                        SD_CS_n <= '0';
                        cmd <= 8;
                        arg <= x"000001AA";
                        crc <= "1000011"; -- CRC is needed.
                        cmd_return_state <= st_cmd8_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd8_res =>
                        finish_delay <= '0';
                        cmd_return_state <= st_cmd8_read_r1;
                        current_state <= st_read_wait;
                    when st_cmd8_read_r1 =>
                        if byte_buff = R1_NO_ERROR_IDLE then
                            -- This card supports CMD8, so it is SDC2+.
                            is_sdc2 <= '1';
                            finish_delay <= '1';
                            cmd_return_state <= st_cmd8_done;
                            current_state <= st_read_dword;
                        elsif byte_buff = R1_ILLIGAL_CMD_IDLE then
                            -- Otherwise, it is SDC1.
                            is_sdc2 <= '0';
                            cmd_return_state <= st_cmd55_req;
                            current_state <= st_finish_delay;
                        else
                            -- TODO: retry count
                            DBG <= x"8";
                            current_state <= st_cmd8_req;
                        end if;
                    when st_cmd8_done =>
                        if dword_buff(11 downto 0) = x"1AA" then
                            -- magic number matches
                            current_state <= st_cmd55_req;
                        else
                            DBG <= x"8";
                            current_state <= st_reject;
                        end if;
                    -- 5.1 CMD55 APP_CMD
                    when st_cmd55_req =>
                        SD_CS_n <= '0';
                        cmd <= 55; -- well, it's decimal.
                        arg <= x"00000000";
                        crc <= "0110010"; -- actually, don't care
                        cmd_return_state <= st_cmd55_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd55_res =>
                        finish_delay <= '1';
                        cmd_return_state <= st_cmd55_done;
                        current_state <= st_read_wait;
                    when st_cmd55_done =>
                        if byte_buff = R1_NO_ERROR_IDLE then
                            -- SD_CS_n <= '1';
                            current_state <= st_acmd41_req;
                        else
                            -- TODO: retry count
                            current_state <= st_cmd55_req; -- ???
                            DBG <= x"5";
                            -- current_state <= st_reject;
                        end if;
                    -- 5.2 ACMD41 APP_SEND_OP_COND
                    when st_acmd41_req =>
                        SD_CS_n <= '0';
                        cmd <= 41;
                        if is_sdc2 = '1' then
                            -- HCS = 1, declares this controller supports high capacity cards.
                            arg <= x"40000000";
                            crc <= "0111011"; -- actually, don't care
                        else
                            arg <= x"00000000"; -- HCS = 0
                            crc <= "1110010"; -- actually, don't care
                        end if;
                        cmd_return_state <= st_acmd41_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_acmd41_res =>
                        finish_delay <= '1';
                        cmd_return_state <= st_acmd41_done;
                        current_state <= st_read_wait;
                    when st_acmd41_done =>
                        if byte_buff = R1_NO_ERROR_IDLE then
                            -- loop until the card responses R1_NO_ERROR_NO_IDLE
                            --                                           ~~~~~~~
                            current_state <= st_cmd55_req;
                        elsif byte_buff = R1_NO_ERROR_NO_IDLE then
                            -- the card is initialized.
                            current_state <= st_cmd58_req;
                        else
                            -- current_state <= st_cmd55_req; -- ???
                            DBG <= x"4";
                            current_state <= st_reject;
                        end if;
                    -- 6. CMD58 READ_OCR
                    when st_cmd58_req =>
                        SD_CS_n <= '0';
                        cmd <= 58;
                        arg <= x"00000000";
                        crc <= "1111110"; -- actually, don't care
                        cmd_return_state <= st_cmd58_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd58_res =>
                        finish_delay <= '0';
                        cmd_return_state <= st_cmd58_read_r1;
                        current_state <= st_read_wait;
                    when st_cmd58_read_r1 =>
                        if byte_buff = R1_NO_ERROR_NO_IDLE then
                            finish_delay <= '1';
                            cmd_return_state <= st_cmd58_done;
                            current_state <= st_read_dword;
                        else
                            -- TODO: retry count
                            DBG <= x"8";
                            current_state <= st_reject;
                        end if;
                    when st_cmd58_done =>
                        -- read CCS bit.
                        -- ref: SD Specifications Part 1 Physical Layer Simplified Specification
                        --     Table 5-1 : OCR Register Definition
                        --     30 Card Capacity Status (CCS)1
                        --     1) This bit is valid only when the card power up status bit is set.
                        is_sdhc <= dword_buff(30); -- CCS, '1' represents high capacity card
                        current_state <= st_cmd16_req;
                    -- 7. CMD16 SET_BLOCKLEN
                    -- This command ensures block length 512 bytes for SDSC. 
                    -- In case of SDHC and SDXC Cards,
                    -- block length of the memory access commands are fixed to 512 bytes.
                    when st_cmd16_req =>
                        SD_CS_n <= '0';
                        cmd <= 16;
                        arg <= x"00000200"; -- 512 bytes per block
                        crc <= "0001010"; -- actually, don't care
                        cmd_return_state <= st_cmd16_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd16_res =>
                        finish_delay <= '1';
                        cmd_return_state <= st_cmd16_done;
                        current_state <= st_read_wait;
                    when st_cmd16_done =>
                        if byte_buff = R1_NO_ERROR_NO_IDLE then
                            current_state <= st_cmd17_req;
                        else
                            DBG <= x"6";
                            current_state <= st_reject;
                        end if;
                    ------------------------------------------------------------------------------
                    -- Bootloader: CMD17 READ_SINGLE_BLOCK
                    when st_cmd17_req =>
                        SD_CS_n <= '0';
                        cmd <= 17;
                        arg <= sector_as_arg;
                        crc <= "1111111"; -- actually, don't care
                        cmd_return_state <= st_cmd17_res;
                        current_state <= st_send_cmd;
                        counter <= 0;
                    when st_cmd17_res =>
                        finish_delay <= '0';
                        cmd_return_state <= st_cmd17_r1;
                        current_state <= st_read_wait;
                    when st_cmd17_r1 =>
                        DBG <= x"C";
                        if byte_buff = R1_NO_ERROR_NO_IDLE then
                            cmd_return_state <= st_cmd17_read_token;
                            current_state <= st_read_byte;
                        else
                            DBG <= x"7";
                            current_state <= st_reject;
                        end if;
                    when st_cmd17_read_token =>
                        DBG <= x"D";
                        if byte_buff = x"FF" then -- not a token, wait
                            cmd_return_state <= st_cmd17_read_token;
                            current_state <= st_read_byte;
                        elsif byte_buff = x"FE" then -- data token
                            cmd_return_state <= st_cmd17_read_data;
                            current_state <= st_read_byte;
                            byte_counter <= 0;
                        elsif byte_buff(7 downto 5) = "000" then -- error token
                            DBG <= x"7";
                            cmd_return_state <= st_reject;
                            current_state <= st_finish_delay;
                        else
                            DBG <= x"7";
                            cmd_return_state <= st_reject;
                        end if;
                    when st_cmd17_read_data =>
                        -- next byte
                        DBG <= x"E";
                        word_buff <= byte_buff & word_buff(WORD_WIDTH - 1 downto 8); -- little-endian
                        if byte_counter = SECTOR_SIZE - 1 then
                            -- assert byte_counter mod WORD_SIZE = WORD_SIZE - 1
                            BL_REQ.ADDR <= conv_std_logic_vector(
                                (sector_counter * SECTOR_SIZE + byte_counter) / WORD_SIZE,
                                BL_REQ.ADDR'length
                            );
                            cmd_return_state <= st_cmd17_read_crc;
                            ram_return_state <= st_read_byte;
                            current_state <= st_cmd17_write_ram;
                            byte_counter <= 0;
                        else
                            if byte_counter mod WORD_SIZE = WORD_SIZE - 1 then
                                BL_REQ.ADDR <= conv_std_logic_vector(
                                    (sector_counter * SECTOR_SIZE + byte_counter) / WORD_SIZE,
                                    BL_REQ.ADDR'length
                                );
                                cmd_return_state <= st_cmd17_read_data;
                                ram_return_state <= st_read_byte;
                                current_state <= st_cmd17_write_ram;
                            else
                                cmd_return_state <= st_cmd17_read_data;
                                current_state <= st_read_byte;
                            end if;
                            byte_counter <= byte_counter + 1;
                        end if;
                    when st_cmd17_write_ram =>
                        BL_REQ.DEN <= '1';
                        BL_REQ.WE_n <= '0';
                        BL_REQ.OE_n <= '1';
                        BL_REQ.DOUT <= word_buff;
                        current_state <= st_cmd17_write_ram_done;
                    when st_cmd17_write_ram_done =>
                        BL_REQ.DEN <= '0';
                        BL_REQ.WE_n <= '1';
                        current_state <= ram_return_state;
                    when st_cmd17_read_crc =>
                        -- eats dummy CRC bytes
                        DBG <= x"F";
                        if byte_counter = 2 - 1 then
                            cmd_return_state <= st_cmd17_done;
                            current_state <= st_finish_delay;
                            byte_counter <= 0;
                        else
                            cmd_return_state <= st_cmd17_read_crc;
                            current_state <= st_read_byte;
                            byte_counter <= byte_counter + 1;
                        end if;
                    when st_cmd17_done =>
                        -- next sector
                        if sector_counter = RAM_SIZE / SECTOR_SIZE - 1 then
                            current_state <= st_done;
                            sector_counter <= 0;
                        else
                            sector_counter <= sector_counter + 1;
                            current_state <= st_cmd17_req;
                        end if;
                    ------------------------------------------------------------------------------
                    -- Subroutines --
                    -- delay for low speed SPI.
                    when st_wait_spi =>
                        if wait_counter = SPI_WAIT_CYCLES - 1 then
                            current_state <= wait_return_state;
                            wait_counter <= 0;
                        else
                            wait_counter <= wait_counter + 1;
                        end if;
                    -- send a command to SPI bus
                    when st_send_cmd =>
                        if counter mod 2 = 0 then
                            SD_MOSI <= packet(CMD_BITS - 1 - counter / 2);
                            sd_sclk_buff <= '0';
                        else
                            sd_sclk_buff <= '1';
                        end if;
                        if counter = (CMD_BITS * 2) - 1 then
                            wait_return_state <= cmd_return_state;
                            current_state <= st_wait_spi;
                            counter <= 0;
                        else
                            wait_return_state <= st_send_cmd;
                            current_state <= st_wait_spi;
                            counter <= counter + 1;
                        end if;
                    -- wait until SD_MISO is low, and read a byte from SPI bus
                    when st_read_wait =>
                        if sd_sclk_buff = '0' then
                            if SD_MISO = '0' then
                                current_state <= st_read_byte;
                                counter <= 0;
                            else
                                wait_return_state <= st_read_wait;
                                current_state <= st_wait_spi;
                                sd_sclk_buff <= '1';
                            end if;
                        else
                            sd_sclk_buff <= '0';
                            wait_return_state <= st_read_wait;
                            current_state <= st_wait_spi;
                        end if;
                    -- read a byte from SPI bus
                    when st_read_byte =>
                        if sd_sclk_buff = '0' then
                            byte_buff(R1_BITS - 1 - counter) <= SD_MISO;
                            if counter = R1_BITS - 1 then
                                if finish_delay = '1' then
                                    wait_return_state <= st_finish_delay;
                                else
                                    wait_return_state <= cmd_return_state;
                                end if;
                                current_state <= st_wait_spi;
                                counter <= 0;
                            else
                                wait_return_state <= st_read_byte;
                                current_state <= st_wait_spi;
                                counter <= counter + 1;
                            end if;
                            sd_sclk_buff <= '1';
                        else
                            sd_sclk_buff <= '0';
                            wait_return_state <= st_read_byte;
                            current_state <= st_wait_spi;
                        end if;
                    -- read 4 bytes from SPI bus
                    when st_read_dword =>
                        if sd_sclk_buff = '0' then
                            dword_buff(DWORD_BUFF_BITS - 1 - counter) <= SD_MISO;
                            if counter = DWORD_BUFF_BITS - 1 then
                                if finish_delay = '1' then
                                    wait_return_state <= st_finish_delay;
                                else
                                    wait_return_state <= cmd_return_state;
                                end if;
                                current_state <= st_wait_spi;
                                counter <= 0;
                            else
                                wait_return_state <= st_read_dword;
                                current_state <= st_wait_spi;
                                counter <= counter + 1;
                            end if;
                            sd_sclk_buff <= '1';
                        else
                            sd_sclk_buff <= '0';
                            wait_return_state <= st_read_dword;
                            current_state <= st_wait_spi;
                        end if;
                    -- delay several clocks after an operation
                    when st_finish_delay =>
                        SD_CS_n <= '1';
                        if sd_sclk_buff = '0' then
                            if counter = 8 - 1 then
                                wait_return_state <= cmd_return_state;
                                current_state <= st_wait_spi;
                                counter <= 0;
                            else
                                wait_return_state <= st_finish_delay;
                                current_state <= st_wait_spi;
                                counter <= counter + 1;
                            end if;
                            sd_sclk_buff <= '1';
                        else
                            sd_sclk_buff <= '0';
                            wait_return_state <= st_finish_delay;
                            current_state <= st_wait_spi;
                        end if;
                    ------------------------------------------------------------------------------
                    when st_reject => -- do nothing
                    when st_done => -- do nothing
                    when others =>
                        current_state <= st_poweron_wait;
                        wait_counter <= 0;
                        counter <= 0;
                end case;
            end if;
        end if;
    end process;

    done_out:
    process(CLK, RST)
    begin
        if RST = '1' then
            DONE <= '0';
        else
            if rising_edge(CLK) then
                if current_state = st_done then
                    DONE <= '1';
                else
                    DONE <= '0';
                end if;
            end if;
        end if;
    end process;

    rejected_out:
    process(CLK, RST)
    begin
        if RST = '1' then
            REJECTED <= '0';
        else
            if rising_edge(CLK) then
                if current_state = st_reject then
                    REJECTED <= '1';
                else
                    REJECTED <= '0';
                end if;
            end if;
        end if;
    end process;
end;
