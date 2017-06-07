library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use work.state.all;
use work.image_info.all;
use work.signals.all;

entity sound is 
    port (
        rst : in std_logic;
        clk : in std_logic;
        hit : in std_logic;
        game_over : in std_logic;
        sound_out : out std_logic
    );
end entity sound;

architecture sound_bhv of sound is 
    constant hit_length : integer := 300;
    constant high_length : integer := 200;
    constant low_length : integer := 100;
    constant game_over_times : integer := 5;
    type state is (s_init, s_high, s_low, s_hit);
    signal current_state : state := s_init;
    signal cnt : integer range 0 to 1023 := 0;
    signal time_cnt : integer range 0 to 1023 := 0;
    signal sound : std_logic;
begin 
    sound_out <= sound;
    main : process(clk, rst)
    begin
        if rst = '1' then
            cnt <= 0;
            time_cnt <= 0;
            current_state <= s_init;
        elsif rising_edge(clk) then
            case current_state is
                when s_init =>
                    if game_over = '1' and time_cnt = 0 then 
                        sound <= '1';
                        cnt <= 1;
                        time_cnt <= 1;
                        current_state <= s_high;
                    elsif hit = '1' then
                        time_cnt <= 0;
                        sound <= '1';
                        cnt <= 1;
                        current_state <= s_hit;
                    end if;
                when s_high =>
                    if cnt = high_length then
                        cnt <= 1;
                        sound <= '0';
                        current_state <= s_low;
                    else
                        cnt <= cnt + 1;
                    end if;
                when s_low =>
                    if cnt = low_length then
                        if time_cnt = game_over_times then
                            current_state <= s_init;
                            cnt <= 0;
                        else
                            current_state <= s_high;
                            sound <= '1';
                            cnt <= 1;
                            time_cnt <= time_cnt + 1;
                        end if;
                    else 
                        cnt <= cnt + 1;
                    end if;
                when s_hit =>
                    if cnt = hit_length then
                        cnt <= 0;
                        sound <= '0';
                        current_state <= s_init;
                    else 
                        cnt <= cnt + 1;
                    end if;
                when others =>
                    sound <= '0';
                    current_state <= s_init;
            end case;
        end if;
    end process;
end architecture sound_bhv;