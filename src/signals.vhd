library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package signals is
    constant WORD_WIDTH: integer := 32;
    constant ADDR_WIDTH: integer := 20;

    -- Usage:
    -- xxx: out RAM_REQ
    -- yyy: in RAM_RES
    type RAM_REQ is record -- ram request
        DOUT: std_logic_vector(WORD_WIDTH - 1 downto 0);
        DEN: std_logic;
        ADDR: std_logic_vector(ADDR_WIDTH - 1 downto 0);
        WE_n: std_logic;
        OE_n: std_logic;
    end record;
    
    type RAM_RES is record
        DIN: std_logic_vector(WORD_WIDTH - 1 downto 0);
        DONE: std_logic;
    end record;
end package;