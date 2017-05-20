library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use work.state.all;
use work.image_info.all;

entity game_logic is
    generic (
        MAX_LIFE: integer : integer := 5;
        MAX_CROW: integer : integer := 4;
        MAX_BULLET_PER_CROW : integer := 4
    );
    port (
      RST: in std_logic; 
      CLK: in std_logic;
      RANDOM_SEED: in std_logic_vector(15 downto 0);

      POS: in std_logic_vector(15 downto 0);
      V: in std_logic_vector(15 downto 0);
      
      game_state : out STATE;
    );
end;
end entity game_logic;

architecture game_logic_bhv of game_logic is 
   
end architecture game_logic_bhv;