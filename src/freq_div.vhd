library IEEE;
use IEEE.std_logic_1164.all;

entity freq_div is
    generic
    (
        DIV: integer := 50
    );
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        O: out std_logic
    );
end;

architecture behavioral of freq_div is
    signal counter: integer range 0 to DIV / 2 - 1;
    signal output: std_logic;    
begin
    O <= output;

    process(CLK, RST)
    begin
        if RST = '1' then
            output <= '0';
            counter <= 0;
        else
            if rising_edge(CLK) then
                if counter = DIV / 2 - 1 then
                    output <= not output;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
end;
