library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
package state is 
	type PLAYER is record
	    pos : std_logic_vector(9 downto 0);
	    life : std_logic_vector(2 downto 0);
	    score : std_logic_vector(19 downto 0);
  	end record PLAYER;

  	type BULLET is record
  		born : std_logic;
  		height : std_logic_vector(9 downto 0);
  	end record BULLET;

  	type BULLETS is array (0 to 3) of BULLET;

  	type CROW is record
  		in_screen : std_logic;
  		row : std_logic_vector(2 downto 0);
  		pos : std_logic_vector(9 downto 0);
  		bullets : BULLETS;
  	end record CROW;

  	type CROWS is array (0 to 7) of CROW;

  	type STATE is record
  		state : std_logic_vector(1 downto 0);
  		crows : CROWS;
  		player1 : PLAYER;
  	end record STATE;
 
end package state;