library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
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
    type state_t is (s_init, s_new_frame, s_render_background, s_render_player, s_render_crow, s_render_bullet, s_done);

    signal current_state : state_t := s_init;
    signal render_addr : integer range 0 to 1048575;
    signal image_id : integer range 0 to 31;
    signal x : integer range 0 to VGA_WIDTH;
    signal y : integer range 0 to VGA_HEIGHT;
    signal image_render_rst : std_logic := '0';
    signal render_done : std_logic;
    signal vga_ram : std_logic := '0';
    signal background_frame : std_logic := '0';
    signal player_frame : integer range 0 to 4 := 0;
    signal current_crow : integer range 0 to 4 := 0;
    signal current_bullet : integer range 0 to 4 := 0;

    component image_render is
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

    main : process(clk, rst)
    begin
        if rst = '1' then
            current_state <= s_init;
            vga_ram <= '0';
            background_frame <= '0';
            player_frame <= 0;
        elsif rising_edge(clk) then
            case current_state is
                when s_init =>
                    current_state <= s_new_frame;
                    vga_ram <= not vga_ram;
                    background_frame <= not background_frame;
                    if player_frame = 3 - 1 then
                        player_frame <= 0;
                    else
                        player_frame <= player_frame + 1;
                    end if;
                    if vga_ram = '0' then
                        vga_addr <= conv_std_logic_vector(graphics_ram_1, vga_addr'length);
                        render_addr <= graphics_ram_2;
                    else
                        vga_addr <= conv_std_logic_vector(graphics_ram_2, vga_addr'length);
                        render_addr <= graphics_ram_1;
                    end if;
                when s_new_frame =>
                    current_state <= s_render_background;
                    x <= 0;
                    y <= 0;
                    image_render_rst <= '1';
                    if background_frame = '0' then
                        image_id <= i_background1;
                    else
                        image_id <= i_background2;
                    end if;
                when s_render_background =>
                    if image_render_rst = '1' then
                        image_render_rst <= '0';
                    elsif render_done = '1' then
                        current_state <= s_render_player;
                        if state.player1.pos < 70 then
                            if player_frame = 0 then
                                image_id <= i_person_left_1;
                            elsif player_frame = 1 then
                                image_id <= i_person_left_2;
                            else
                                image_id <= i_person_left_3;
                            end if;
                        elsif state.player1.pos > 130 then
                            if player_frame = 0 then
                                image_id <= i_person_right_1;
                            elsif player_frame = 1 then
                                image_id <= i_person_right_2;
                            else
                                image_id <= i_person_right_3;
                            end if;
                        else
                            if player_frame = 0 then
                                image_id <= i_person_middle_1;
                            elsif player_frame = 1 then
                                image_id <= i_person_middle_2;
                            else 
                                image_id <= i_person_middle_3;
                            end if;
                        end if;
                        x <= state.player1.pos;
                        y <= 255;
                        image_render_rst <= '1';
                    end if;
                when s_render_player =>
                    if image_render_rst = '1' then
                        image_render_rst <= '0';
                    elsif render_done = '1' then
                        current_state <= s_render_crow;
                        current_crow <= 0;
                        if state.crows(current_crow).in_screen = '1' then
                            x <= state.crows(current_crow).pos;
                            y <= 50;
                            image_id <= i_crow;
                            image_render_rst <= '1';
                        end if;
                    end if; 
                when s_render_crow =>
                    if image_render_rst = '1' then
                        image_render_rst <= '0';
                    elsif state.crows(current_crow).in_screen = '0' or render_done = '1' then
                        if current_crow = 4 - 1 then
                            current_state <= s_render_bullet;
                            current_crow <= 0;
                            current_bullet <= 0;
                            if state.crows(0).bullets(current_bullet).in_screen = '1' then
                                x <= state.crows(0).pos;
                                y <= state.crows(0).bullets(current_bullet).height;
                                image_id <= i_bullet;
                                image_render_rst <= '1';
                            end if;
                        else
                            if state.crows(current_crow + 1).in_screen = '1' then
                                x <= state.crows(current_crow + 1).pos;
                                y <= 50;
                                image_id <= i_bullet;
                                image_render_rst <= '1';
                            end if;
                            current_crow <= current_crow + 1;
                        end if;
                    end if;
                when s_render_bullet => 
                    if image_render_rst = '1' then
                        image_render_rst <= '0';
                    elsif state.crows(current_crow).bullets(current_bullet).in_screen = '0' or render_done = '1' then
                        if current_bullet = 4 - 1 then
                            current_bullet <= 0;
                            if current_crow = 4 - 1 then
                                current_crow <= 0;
                                current_state <= s_done;
                            else
                                if state.crows(current_crow + 1).bullets(0).in_screen = '1' then
                                    x <= state.crows(current_crow + 1).pos;
                                    y <= state.crows(current_crow + 1).bullets(0).height;
                                    image_id <= i_bullet;
                                    image_render_rst <= '1';
                                end if;
                                current_crow <= current_crow + 1;
                            end if;
                        else
                            if state.crows(current_crow).bullets(current_bullet + 1).in_screen = '1' then
                                x <= state.crows(current_crow).pos;
                                y <= state.crows(current_crow).bullets(current_bullet + 1).height;
                                image_id <= i_bullet;
                                image_render_rst <= '1';
                            end if;
                            current_bullet <= current_bullet + 1;
                        end if;
                    end if;
                when s_done =>
                    if vga_done = '1' then
                        current_state <= s_init;
                    end if;
                when others =>
                    current_state <= s_init;
            end case;
        end if;
    end process;
end architecture render_bhv;