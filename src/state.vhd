library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
package state is 
	type PLAYER is record
	    pos : integer range 0 to 319;
	    life : integer range 0 to 5;
	    score : integer range 0 to 1048575;
  	end record PLAYER;

  	type BULLET is record
  		born : std_logic;
  		height : integer range 0 to 479;
  	end record BULLET;

  	type BULLETS is array (0 to 3) of BULLET;

  	type CROW is record
  		in_screen : std_logic;
  		row : integer range 0 to 3;
  		pos : integer range 0 to 319;
  		bullets : BULLETS;
  	end record CROW;

  	type CROWS is array (0 to 7) of CROW;

  	type STATE is record
  		state : integer range 0 to 7;
  		crows : CROWS;
  		player1 : PLAYER;
  	end record STATE;
 
end package state;