library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
package image_info is 
  	type INTEGERS is array (0 to 63) of integer;
  	constant image_width : INTEGERS := (320, 320, 252, 72, 30, 163, 116, 109, 120, 93, 109, 106, 124, 125, 122, 44, 290);
    constant image_height : INTEGERS := (480, 480, 105, 70, 66, 285, 211, 209, 205, 213, 214, 218, 218, 221, 216, 23, 121);
    constant image_address : INTEGERS := (614400, 691200, 768000, 781230, 783750, 784740, 807968, 820206, 831597, 843897, 
                                          853802, 865465, 877019, 890535, 904348, 917524, 918030);
end package image_info;