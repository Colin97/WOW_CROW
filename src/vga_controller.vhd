library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.signals.all;

entity vga_controller is
    generic
    (
        clock_freq: integer := 25000000;

        h_active: integer := 640;
        h_front_porch: integer := 16;
        h_sync_pulse: integer := 96;
        h_back_porch: integer := 48;

        v_active: integer := 480;
        v_front_porch: integer := 10;
        v_sync_pulse: integer := 2;
        v_back_porch: integer := 33
        -- TODO: sync pole
    );
    port
    (
        VGA_CLK: in std_logic;
        RST: in std_logic;

        -- Graphics RAM
        -- data should be ready before next clock positive edge.
        BASE_ADDR: std_logic_vector(ADDR_WIDTH - 1 downto 0);
        VGA_REQ: out RAM_REQ;
        VGA_RES: in RAM_RES;

        -- outputs
        HSYNC: out std_logic;
        VSYNC: out std_logic;
        RED: out std_logic_vector(4 downto 0);
        GREEN: out std_logic_vector(5 downto 0);
        BLUE: out std_logic_vector(4 downto 0);
        DONE: out std_logic
    );
end;

architecture behavorial of vga_controller is
    constant h_whole: integer := h_active + h_front_porch + h_sync_pulse + h_back_porch;
    constant v_whole: integer := v_active + v_front_porch + v_sync_pulse + v_back_porch;
    signal next_x: std_logic_vector(12 downto 0);
    signal next_y: std_logic_vector(12 downto 0);
    signal h_counter: std_logic_vector(12 downto 0);
    signal v_counter: std_logic_vector(12 downto 0);

    signal OUT_EN, next_en: std_logic;
begin
    OUT_EN <= '1' when (h_counter < h_active) and (v_counter < v_active) and RST = '0' else '0';
    next_en <= '1' when (next_x < h_active) and (next_y < v_active) and RST = '0' else '0';

    -- prefetch
    VGA_REQ.DEN <= '0';
    VGA_REQ.ADDR <= BASE_ADDR +
                    conv_std_logic_vector(conv_integer(next_y) * h_active,
                                          VGA_REQ.ADDR'length) +
                    next_x;
    VGA_REQ.WE_n <= '1';
    VGA_REQ.OE_n <= not next_en;

    -- next (x, y)
    process(h_counter, v_counter)
    begin
        if h_counter = h_whole - 1 then -- new line
            next_x <= conv_std_logic_vector(0, h_counter'length);
            if v_counter = v_whole - 1 then -- new scene
                next_y <= conv_std_logic_vector(0, v_counter'length);
            else
                next_y <= v_counter + 1;
            end if;
        else
            next_x <= h_counter + 1;
            next_y <= v_counter;
        end if;
    end process;
    
    -- done
    DONE <= '1' when next_y >= v_active else '0';

    -- starts at h_active and v_active
    HSYNC <= '0' when (h_counter >= h_active + h_front_porch) and (h_counter < h_active + h_front_porch + h_sync_pulse) else '1';
    VSYNC <= '0' when (v_counter >= v_active + v_front_porch) and (v_counter < v_active + v_front_porch + v_sync_pulse) else '1';

    process(VGA_CLK, RST)
    begin
        if RST = '1' then
            h_counter <= conv_std_logic_vector(0, h_counter'length);
            v_counter <= conv_std_logic_vector(0, v_counter'length);
            RED <= (others => '0');
            GREEN <= (others => '0');
            BLUE <= (others => '0');
        else
            if rising_edge(VGA_CLK) then
                h_counter <= next_x;
                v_counter <= next_y;
                if next_en = '1' then
                    RED <= VGA_RES.DIN(15 downto 11);
                    GREEN <= VGA_RES.DIN(10 downto 6) & "0";
                    BLUE <= VGA_RES.DIN(5 downto 1);
                else
                    RED <= (others => '0');
                    GREEN <= (others => '0');
                    BLUE <= (others => '0');
                end if;
            end if;
        end if;
    end process;
end;