LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

entity cfpga is 
    port
    (
    ------------------efpga mem----------------
        CE_MEMORY_WE        	: in std_logic;
        CE_MEMORY_OE        	: in std_logic;
        CE_MEMORY_CE        	: in std_logic;
        CE_MEMORY_ADDR      	: in std_logic_vector(19 downto 0);
        CE_MEMORY_DATA      	: inout std_logic_vector(31 downto 0);
    -----------------memory 1M-----------------
        BASERAMWE           	: out std_logic;
        BASERAMOE           	: out std_logic;
        BASERAMCE           	: out std_logic;
        BASERAMADDR         	: out std_logic_vector(19 downto 0);
        BASERAMDATA         	: inout std_logic_vector(31 downto 0)
    );
end entity;

architecture behavioral of cfpga is                                                            
begin
    BASERAMWE <= CE_MEMORY_WE;
    BASERAMOE <= CE_MEMORY_OE;
    BASERAMCE <= CE_MEMORY_CE;
    BASERAMADDR <= CE_MEMORY_ADDR;
    BASERAMDATA <= CE_MEMORY_DATA when CE_MEMORY_OE='1' else (others => 'Z');
    CE_MEMORY_DATA <= BASERAMDATA when CE_MEMORY_OE='0' else (others => 'Z');
end;