library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

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
        -- data should be ready at next clock positive edge.
        REN: out std_logic;
        X_ADDR: out std_logic_vector(15 downto 0);
        Y_ADDR: out std_logic_vector(15 downto 0);
        RED_DA: in std_logic_vector(4 downto 0);
        GREEN_DA: in std_logic_vector(5 downto 0);
        BLUE_DA: in std_logic_vector(4 downto 0);

        -- outputs
        HSYNC: out std_logic;
        VSYNC: out std_logic;
        RED: out std_logic_vector(4 downto 0);
        GREEN: out std_logic_vector(5 downto 0);
        BLUE: out std_logic_vector(4 downto 0)
    );
end;

architecture behavorial of vga_controller is
    constant h_whole: integer := h_active + h_front_porch + h_sync_pulse + h_back_porch;
    constant v_whole: integer := v_active + v_front_porch + v_sync_pulse + v_back_porch;
    signal next_x: std_logic_vector(12 downto 0);
    signal next_y: std_logic_vector(12 downto 0);
    signal h_counter: std_logic_vector(12 downto 0);
    signal v_counter: std_logic_vector(12 downto 0);

    signal OUT_EN: std_logic;
begin
    OUT_EN <= '1' when (h_counter < h_active) and (v_counter < v_active) and RST = '0' else '0';

    RED <= RED_DA when OUT_EN = '1' else "00000";
    GREEN <= GREEN_DA when OUT_EN = '1' else "000000";
    BLUE <= BLUE_DA when OUT_EN = '1' else "00000";

    -- prefetch
    X_ADDR <= "000" & next_x;
    Y_ADDR <= "000" & next_y;
    REN <= '1' when (next_x < h_active) and (next_y < v_active) and RST = '0' else '0';

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

    -- starts at h_active and v_active
    HSYNC <= '1' when (h_counter >= h_active + h_front_porch) and (h_counter < h_active + h_front_porch + h_sync_pulse) else '0';
    VSYNC <= '1' when (v_counter >= v_active + v_front_porch) and (v_counter < v_active + v_front_porch + v_sync_pulse) else '0';

    process(VGA_CLK, RST)
    begin
        if RST = '1' then
            h_counter <= conv_std_logic_vector(0, h_counter'length);
            v_counter <= conv_std_logic_vector(0, v_counter'length);
        else
            if rising_edge(VGA_CLK) then
                h_counter <= next_x;
                v_counter <= next_y;
            end if;
        end if;
    end process;
end;