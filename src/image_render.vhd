library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use work.image_info.all;
use work.signals.all;

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
        rst, clk : in std_logic;
        
        render_req: out RAM_REQ;
        render_res: in RAM_RES;
        done : out std_logic
    );
end entity image_render;

architecture image_render_bhv of image_render is 
    type state is (s_init, s_read, s_write, s_done);

    signal current_state : state := s_init;
    signal data : std_logic_vector(15 downto 0);

    shared variable row : integer range 0 to VGA_HEIGHT * 2;
    shared variable col : integer range 0 to VGA_WIDTH * 2;
    shared variable cnt : integer range 0 to 1024 * 1024 * 2 - 1;
    signal image_pixel: std_logic_vector(15 downto 0);
begin
    render_req.DOUT <= x"0000" & data;
    done <= '1' when current_state = s_done else '0';
    image_pixel <= render_res.DIN(15 downto 0) when cnt mod 2 = 0 else render_res.DIN(31 downto 16);

    main : process(clk, rst)
    begin
        if rst = '1' then
            current_state <= s_init;
            row := 0;
            col := 0;
            cnt := 0;
            render_req.OE_n <= '0';
            render_req.WE_n <= '1';
            render_req.DEN <= '0';
            render_req.ADDR <= conv_std_logic_vector(0, render_req.ADDR'length);
                data <= x"0000";
        elsif rising_edge(clk) then
            case current_state is
                when s_init =>
                    current_state <= s_read;
                    row := 0;
                    col := 0;
                    cnt := 0;
                    render_req.OE_n <= '0';
                    render_req.WE_n <= '1';
                    render_req.DEN <= '0';
                    render_req.ADDR <= conv_std_logic_vector(image_address(image_id) + cnt / 2,
                                                             render_req.ADDR'length);
                when s_read =>
                    if render_res.DONE = '1' then
                        if (row + y) < 0 or (col + x) < 0 or (row + y) >= VGA_HEIGHT or (col + x) >= VGA_WIDTH / 2 or image_pixel(0) = '0' then
                            current_state <= s_write;
                        else
                            current_state <= s_write;
                            data <= image_pixel;
                            render_req.OE_n <= '1';
                            render_req.WE_n <= '0';
                            render_req.DEN <= '1';
                            render_req.ADDR <=
                                conv_std_logic_vector(base_address +
                                                      (row + y) * VGA_WIDTH +
                                                      (col + x), render_req.ADDR'length);
                        end if;
                    end if;
                when s_write =>
                    if render_res.DONE = '1' then
                        col := col + 1;
                        cnt := cnt + 1;
                        if col = image_width(image_id) then
                            col := 0;
                            row := row + 1;
                        end if;
                        if row = image_height(image_id) then
                            current_state <= s_done;
                        else
                            current_state <= s_read;
                            render_req.OE_n <= '0';
                            render_req.WE_n <= '1';
                            render_req.DEN <= '0';
                            render_req.ADDR <=
                                conv_std_logic_vector(image_address(image_id) + cnt / 2,
                                                      render_req.ADDR'length);
                        end if;
                    end if;
                when s_done =>
                    current_state <= s_done;
                when others =>
                    current_state <= s_init;
            end case;
        end if;
    end process;
end architecture image_render_bhv;