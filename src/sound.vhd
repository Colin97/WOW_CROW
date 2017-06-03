library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use work.state.all;
use work.image_info.all;
use work.signals.all;

entity sound is 
    generic (
        length : integer := 300
    );
    port (
        rst : in std_logic;
        clk : in std_logic;
        hit : in std_logic;
        sound_out : out std_logic
    );
end entity sound;

architecture sound_bhv of sound is 
    signal cnt : integer range 0 to 1023 := 0;
begin 
    sound_out <= '1' when cnt /= 0 else '0';
    main : process(clk, rst)
    begin
        if rst = '1' then
            cnt <= 0;
        elsif rising_edge(clk) then
            if cnt /= 0 then
                if cnt = length then
                    cnt <= 0;
                else 
                    cnt <= cnt + 1;
                end if;
           end if;
           if hit = '1' then
               cnt <= 1;
           end if;
        end if;
    end process;
end architecture sound_bhv;