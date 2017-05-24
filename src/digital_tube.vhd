library IEEE;
use IEEE.std_logic_1164.all;

entity digital_tube is
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        DA: in std_logic_vector(23 downto 0);
        DS_DP: out std_logic;
        DS: out std_logic_vector(6 downto 0); -- 6-0: a-g
        DS_EN: out std_logic_vector(5 downto 0)
    );
end;

architecture Behavioral of digital_tube is
    component digital_tube_decoder is
        port
        (
            N: in std_logic_vector(3 downto 0);
            O: out std_logic_vector(6 downto 0) -- 6-0: a-g
        );
    end component;
    
    signal N: std_logic_vector(3 downto 0);
    signal SEL: std_logic_vector(5 downto 0);
begin
    digital_tube_decoder_inst: digital_tube_decoder
    port map
    (
        N => N,
        O => DS
    );

    DS_EN <= SEL;
    DS_DP <= RST; -- TODO

    process(RST, SEL, DA)
    begin
        if RST = '1' then
            N <= x"8";
        else
            case SEL is
                when "000001" =>
                    N <= DA(3 downto 0);
                when "000010" =>    
                    N <= DA(7 downto 4);
                when "000100" =>
                    N <= DA(11 downto 8);
                when "001000" =>
                    N <= DA(15 downto 12);
                when "010000" =>
                    N <= DA(19 downto 16);
                when "100000" =>
                    N <= DA(23 downto 20);
                when others =>
                    N <= DA(3 downto 0);
            end case;
        end if;
    end process;
    
    process(CLK, RST)
    begin
        if RST = '1' then
            SEL <= "111111";
        else
            if rising_edge(CLK) then
                case SEL is
                    when "000001" =>
                        SEL <= "000010";
                    when "000010" =>
                        SEL <= "000100";
                    when "000100" =>
                        SEL <= "001000";
                    when "001000" =>
                        SEL <= "010000";
                    when "010000" =>
                        SEL <= "100000";
                    when "100000" =>
                        SEL <= "000001";
                    when others =>
                        SEL <= "000001";
                end case;
            end if;
        end if;
    end process;
end;

