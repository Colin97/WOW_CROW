library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.image_info.all;

entity image_render is 
    generic (
        VGA_WIDTH : integer := 640;
        VGA_HEIGHT : integer := 480
    );
    port (
        image_id : in integer range 0 to 31;
        base_address : in integer range 0 to 1048575;
        x : in integer range 0 to VGA_WIDTH;
        y : in integer range 0 to VGA_HEIGHT;
        rst, clock : in std_logic;
        din : in std_logic_vector(31 downto 0);
        dout : out std_logic_vector(31 downto 0);
        we_n, oe_n: out std_logic;
        addr : out std_logic_vector(19 downto 0);
        sram_done : in std_logic;
        done : out std_logic
    );
end entity image_render;

architecture image_render_bhv of image_render is 
    type state is (init, read, write, done);
    signal current_state : state := init;
    signal data : std_logic_vector(31 downto 0);
    signal dout_en : std_logic;
    shared variable row : integer;
    shared variable col : integer;
    shared variable cnt : integer;
begin 
    dout <= data when dout_en = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    main : process(clk, rst)
    begin
        if rst = '1' then
            current_state <= read;
            row := 0;
            col := 0;
            cnt := 0;
            done <= '0';
            oe_n <= '0';
            we_n <= '1';
            dout_en <= '0';
            addr <= image_address(image_id) + cnt / 2;
        elsif clk = '1' and clk'event then
            case current_state is
                when read =>
                    if sram_done = '1' then
                        if cnt MOD 2 = 0 then
                            data(15 downto 0) <= din(15 downto 0);
                        else
                            data(15 downto 0) <= din(31 downto 16);
                        end if;
                        current_state <= write;
                        oe_n <= '1';
                        we_n <= '0';
                        addr <= base_address + (row + x) * VGA_WIDTH + (col + y);
                        dout_en <= '1';
                    end if;
                when write =>
                    if sram_done = '1' then
                        col := col + 1;
                        cnt := cnt + 1;
                        if col = image_width(image_id) then
                            col := 0;
                            row := row + 1;
                        end if;
                        if row = image_height(image_id) then
                            current_state <= done;
                            done <= '1';
                        else
                            current_state <= read;
                            oe_n <= '0';
                            we_n <= '1';
                            dout_en <= '0';
                            addr <= image_address(image_id) + cnt / 2;
                        end if;
                    end if;
                when others =>
                    current_state <= current_state;
            end case;
        end if;
    end process;
end architecture image_render_bhv;