library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith;

-- for zapai remote controller
entity remote_controller is
    generic
    (
        CLK_FREQ: integer := 1000000;
        TIMEOUT_MS: integer := 150
    );
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        DATA: in std_logic_vector(31 downto 0);
        READY: in std_logic;
        REPEAT: in std_logic;

        OK: out std_logic;
        UP: out std_logic
    );
end;

architecture behavioral of remote_controller is
    type state is (st_read_wait, st_read, st_checksum, st_data_out, st_error);
    
    constant TIMEOUT_CLOCKS: integer := CLK_FREQ / 1000 * TIMEOUT_MS;

    signal timeout_counter: integer range 0 to TIMEOUT_CLOCKS - 1;
    signal last_ready: std_logic;
    signal addr: std_logic_vector(15 downto 0);
    signal user_code, user_code_n: std_logic_vector(7 downto 0);
    signal correct: std_logic;
begin
    addr <= DATA(15 downto 0);
    user_code <= DATA(23 downto 16);
    user_code_n <= DATA(31 downto 24);
    
    correct <= '1' when addr = x"FF00" and user_code = not user_code_n else '0';

    process(CLK, RST)
    begin
        if RST = '1' then
            OK <= '0';
            UP <= '0';
        elsif rising_edge(CLK) then
            if last_ready = '0' and READY = '1' then
                if correct = '1' then
                    case user_code is
                        when x"1C" => -- OK
                            OK <= '1';
                        when x"18" => -- ^
                            UP <= '1';
                        when others =>
                    end case;
                    timeout_counter <= 0;
                end if;
            else
                if timeout_counter = TIMEOUT_CLOCKS - 1 then -- timed out
                    OK <= '0';
                    UP <= '0';
                    timeout_counter <= 0;
                else
                    timeout_counter <= timeout_counter + 1;
                end if;
            end if;
        end if;
    end process;

    process(CLK, RST)
    begin
        if RST = '1' then
            last_ready <= '0';
        elsif rising_edge(CLK) then
            last_ready <= READY;
        end if;
    end process;
end;
