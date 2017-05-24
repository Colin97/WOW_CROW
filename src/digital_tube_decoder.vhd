library IEEE;
use IEEE.std_logic_1164.all;

entity digital_tube_decoder is
    port
    (
        N : in std_logic_vector(3 downto 0);
        O : out std_logic_vector(6 downto 0) -- 6-0: a-g
    );
end;

architecture behavioral of digital_tube_decoder is
begin
    process(N)
    begin
        case N is
            when x"0" => 
                O <= "1111110";
            when x"1" =>
                O <= "0110000";
            when x"2" =>
                O <= "1101101";
            when x"3" =>
                O <= "1111001";
            when x"4" =>
                O <= "0110011";
            when x"5" =>
                O <= "1011011";
            when x"6" =>
                O <= "1011111";
            when x"7" =>
                O <= "1110000";
            when x"8" =>
                O <= "1111111";
            when x"9" =>
                O <= "1111011";
            when x"A" =>
                O <= "1110111";
            when x"B" =>
                O <= "0011111";
            when x"C" =>
                O <= "1001110";
            when x"D" =>
                O <= "0111101";
            when x"E" =>
                O <= "1001111";
            when x"F" =>
                O <= "1000111";
            when others =>
                O <= "XXXXXXX";
        end case;
    end process;
end;
