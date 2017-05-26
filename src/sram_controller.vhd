library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.signals.all;

entity sram_controller is
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        
        -- connect to sram
        RAM_ADDR: out std_logic_vector(ADDR_WIDTH - 1 downto 0);
        RAM_DQ: inout std_logic_vector(WORD_WIDTH - 1 downto 0);
        RAM_WE_n: out std_logic;
        RAM_OE_n: out std_logic;
        
        -- internal wires
        BOOTLOADER_REQ: in RAM_REQ;
        BOOTLOADER_RES: out RAM_RES;
        VGA_REQ: in RAM_REQ;
        VGA_RES: out RAM_RES;
        RENDERER_REQ: in RAM_REQ;
        RENDERER_RES: out RAM_RES
    );
end;

architecture behavioral of sram_controller is
    type state_t is (st_init, st_vga, st_renderer1, st_renderer2);
    
    signal den: std_logic;
    signal dout, vga_data: std_logic_vector(WORD_WIDTH - 1 downto 0);
    signal current_state: state_t;
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            current_state <= st_init;
            vga_data <= x"00000000";
        else
            if rising_edge(CLK) then
                case current_state is
                    when st_init =>
                        current_state <= st_vga;
                    when st_vga =>
                        vga_data <= RAM_DQ; -- keep data for vga
                        current_state <= st_renderer1;
                        -- current_state <= st_vga; -- FIXME
                    when st_renderer1 =>
                        -- current_state <= st_renderer2;
                        current_state <= st_vga; -- FIXME
                    when st_renderer2 =>
                        current_state <= st_vga;
                    when others =>
                        current_state <= st_init;
                end case;
            end if;
        end if;
    end process;
    
    VGA_RES.DIN <= RAM_DQ when current_state = st_vga else vga_data;
    BOOTLOADER_RES.DIN <= RAM_DQ;
    RENDERER_RES.DIN <= RAM_DQ;
    RAM_DQ <= dout when den = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

    -- dispatcher
    process(current_state, BOOTLOADER_REQ, VGA_REQ, RENDERER_REQ)
    begin
        case current_state is
            when st_init =>
                RAM_ADDR <= BOOTLOADER_REQ.ADDR;
                dout <= BOOTLOADER_REQ.DOUT;
                den <= BOOTLOADER_REQ.DEN;
                RAM_WE_n <= BOOTLOADER_REQ.WE_n;
                RAM_OE_n <= BOOTLOADER_REQ.OE_n;
                BOOTLOADER_RES.DONE <= '1';
                VGA_RES.DONE <= '0';
                RENDERER_RES.DONE <= '0';
            when st_vga =>
                RAM_ADDR <= VGA_REQ.ADDR;
                dout <= VGA_REQ.DOUT;
                den <= VGA_REQ.DEN;
                RAM_WE_n <= VGA_REQ.WE_n;
                RAM_OE_n <= VGA_REQ.OE_n;
                BOOTLOADER_RES.DONE <= '0';
                VGA_RES.DONE <= '1';
                RENDERER_RES.DONE <= '0';
            when st_renderer1 =>
                RAM_ADDR <= RENDERER_REQ.ADDR;
                dout <= RENDERER_REQ.DOUT;
                den <= RENDERER_REQ.DEN;
                RAM_WE_n <= RENDERER_REQ.WE_n;
                RAM_OE_n <= RENDERER_REQ.OE_n;
                BOOTLOADER_RES.DONE <= '0';
                VGA_RES.DONE <= '0';
                RENDERER_RES.DONE <= '1';
            when st_renderer2 =>
                RAM_ADDR <= RENDERER_REQ.ADDR;
                dout <= RENDERER_REQ.DOUT;
                den <= RENDERER_REQ.DEN;
                RAM_WE_n <= RENDERER_REQ.WE_n;
                RAM_OE_n <= RENDERER_REQ.OE_n;
                BOOTLOADER_RES.DONE <= '0';
                VGA_RES.DONE <= '0';
                RENDERER_RES.DONE <= '1';
            when others =>
        end case;
end process;
end;
