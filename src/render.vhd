library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.state.all;
use work.image_info.all;

entity render is 
    generic (
        VGA_WIDTH : integer := 640;
        VGA_HEIGHT : integer := 480
    );
    port (
        rst, clk : in std_logic;
        state : in STATE;
        vga_done : in std_logic;
        vga_addr : out std_logic_vector(19 downto 0);
        sram_din : in std_logic_vector(31 downto 0);
        sram_dout : out std_logic_vector(31 downto 0);
        sram_we_n, sram_oe_n: out std_logic;
        sram_addr : out std_logic_vector(19 downto 0);
        sram_done : in std_logic
    );
end entity render;

architecture render_bhv of render is 
    type state is (s_init, s_render_background, s_render_player, s_render_crow, s_render_bullet, s_done);
    signal current_state : state := s_init;
    signal image_id : integer range 0 to 31;
    signal render_addr : integer range 0 to 1048575;
    signal x : integer range 0 to VGA_WIDTH;
    signal y : integer range 0 to VGA_HEIGHT;
    signal image_render_rst : std_logic;
    signal render_done : std_logic;
    component freq_div is
        generic (
            VGA_WIDTH : integer := 640;
            VGA_HEIGHT : integer := 480
        );
        port (
            image_id : in integer range 0 to 31;
            base_address : in integer range 0 to 1048575;
            x : in integer range 0 to VGA_WIDTH;
            y : in integer range 0 to VGA_HEIGHT;
            rst, clk : in std_logic;
            din : in std_logic_vector(31 downto 0);
            dout : out std_logic_vector(31 downto 0);
            we_n, oe_n: out std_logic;
            addr : out std_logic_vector(19 downto 0);
            sram_done : in std_logic;
            done : out std_logic
        );
    end component;
begin 
    image_render_inst : image_render 
    port map (
        image_id => image_id,
        base_address => render_addr,
        x => x,
        y => y,
        rst => image_render_rst,
        clk => clk,
        din => sram_din,
        dout => sram_dout,
        we_n => sram_we_n,
        oe_n => sram_oe_n,
        addr => sram_addr,
        sram_done => sram_done,
        done => render_done
    );
end architecture render_bhv;