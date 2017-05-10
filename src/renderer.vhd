library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity renderer is
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        X: in std_logic_vector(15 downto 0);
        Y: in std_logic_vector(15 downto 0);

        RED_DA: out std_logic_vector(4 downto 0);
        GREEN_DA: out std_logic_vector(5 downto 0);
        BLUE_DA: out std_logic_vector(4 downto 0);

        Ax: in std_logic_vector(15 downto 0);
        Ay: in std_logic_vector(15 downto 0)
    );
end;

architecture behavioral of renderer is
    signal red: std_logic_vector(4 downto 0);
    signal green: std_logic_vector(5 downto 0);
    signal blue: std_logic_vector(4 downto 0);

    signal region: std_logic_vector(1 downto 0);
    signal box_x, box_y: std_logic_vector(15 downto 0);
begin
    RED_DA <= red;
    GREEN_DA <= green;
    BLUE_DA <= blue;

    region(0) <= '1' when X >= 320 else '0';
    region(1) <= '1' when Y >= 240 else '0';
    box_x <= conv_std_logic_vector(320, box_x'length) - (Ay(15) & Ay(15) & Ay(15) & Ay(15) & Ay(15) & Ay(15) & Ay(15 downto 6));
    box_y <= conv_std_logic_vector(240, box_y'length) - (Ax(15) & Ax(15) & Ax(15) & Ax(15) & Ax(15) & Ax(15) & Ax(15) & Ax(15 downto 7));

    process(CLK, RST)
    begin
        if RST = '1' then
            red <= "00000";
            green <= "000000";
            blue <= "00000";
        else
            if rising_edge(CLK) then
                if (X >= box_x - 10 and X < box_x + 10) and
                   (Y >= box_y - 10 and Y < box_y + 10) then
                    red <= "11111";
                    green <= "111111";
                    blue <= "11111";
                else
                    case region is
                        when "00" =>
                            red <= "11111";
                            green <= "000000";
                            blue <= "00000";
                        when "01" =>
                            red <= "00000";
                            green <= "111111";
                            blue <= "00000";
                        when "10" =>
                            red <= "00000";
                            green <= "000000";
                            blue <= "11111";
                        when "11" =>
                            red <= "00000";
                            green <= "100000";
                            blue <= "10000";
                        when others =>
                            red <= "00000";
                            green <= "000000";
                            blue <= "00000";
                    end case;
                end if;
            end if;
        end if;
    end process;
end;
