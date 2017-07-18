## Generated SDC file "wow_crow.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.2 Build 203 01/18/2017 SJ Lite Edition"

## DATE    "Sat Jul 08 00:33:53 2017"

##
## DEVICE  "EP4CE15F17C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLK} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLK}]
create_clock -name {freq_div:freq_div_1000_inst|output} -period 1.000 -waveform { 0.000 0.500 } [get_registers {freq_div:freq_div_1000_inst|output}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {CLK_50M} -source [get_ports {CLK}] -phase 180.000 -master_clock {CLK} [get_nets {pll_inst|altpll_component|auto_generated|wire_pll1_clk[0]}] 
create_generated_clock -name {CLK_25M} -source [get_ports {CLK}] -divide_by 2 -master_clock {CLK} [get_nets {pll_inst|altpll_component|auto_generated|wire_pll1_clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[0]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[1]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[2]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[3]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[4]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[5]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[6]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[7]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[8]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[9]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[10]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[11]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[12]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[13]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[14]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[15]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[16]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[17]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[18]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[19]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[20]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[21]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[22]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[23]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[24]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[25]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[26]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[27]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[28]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[29]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[30]}]
set_input_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[13]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[14]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[15]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[16]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[17]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[18]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_ADDR[19]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_CS_n}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[0]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[1]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[2]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[3]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[4]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[5]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[6]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[7]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[8]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[9]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[10]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[11]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[12]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[13]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[14]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[15]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[16]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[17]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[18]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[19]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[20]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[21]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[22]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[23]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[24]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[25]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[26]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[27]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[28]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[29]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[30]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_DQ[31]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_OE_n}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_50M}]  2.000 [get_ports {RAM_WE_n}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_BLUE[0]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_BLUE[1]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_BLUE[2]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_BLUE[3]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_BLUE[4]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[0]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[1]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[2]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[3]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[4]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_GREEN[5]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_HSYNC}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_RED[0]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_RED[1]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_RED[2]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_RED[3]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_RED[4]}]
set_output_delay -add_delay -max -clock [get_clocks {CLK_25M}]  1.000 [get_ports {VGA_VSYNC}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

set_net_delay -max 2.000 -from [get_ports {RAM_DQ[0] RAM_DQ[1] RAM_DQ[2] RAM_DQ[3] RAM_DQ[4] RAM_DQ[5] RAM_DQ[6] RAM_DQ[7] RAM_DQ[8] RAM_DQ[9] RAM_DQ[10] RAM_DQ[11] RAM_DQ[12] RAM_DQ[13] RAM_DQ[14] RAM_DQ[15] RAM_DQ[16] RAM_DQ[17] RAM_DQ[18] RAM_DQ[19] RAM_DQ[20] RAM_DQ[21] RAM_DQ[22] RAM_DQ[23] RAM_DQ[24] RAM_DQ[25] RAM_DQ[26] RAM_DQ[27] RAM_DQ[28] RAM_DQ[29] RAM_DQ[30] RAM_DQ[31]}] -to [get_nets {render_inst|image_render_inst|image_pixel[1]~0 render_inst|image_render_inst|image_pixel[2]~1 render_inst|image_render_inst|image_pixel[3]~2 render_inst|image_render_inst|image_pixel[4]~3 render_inst|image_render_inst|image_pixel[5]~4 render_inst|image_render_inst|image_pixel[6]~5 render_inst|image_render_inst|image_pixel[7]~6 render_inst|image_render_inst|image_pixel[8]~7 render_inst|image_render_inst|image_pixel[9]~8 render_inst|image_render_inst|image_pixel[10]~9 render_inst|image_render_inst|image_pixel[11]~10 render_inst|image_render_inst|image_pixel[12]~11 render_inst|image_render_inst|image_pixel[13]~12 render_inst|image_render_inst|image_pixel[14]~13 render_inst|image_render_inst|image_pixel[15]~14}]
set_net_delay -max 2.000 -from [get_nets {render_inst|image_render_inst|render_req.ADDR[0] render_inst|image_render_inst|render_req.ADDR[0]~20 render_inst|image_render_inst|render_req.ADDR[0]~21 render_inst|image_render_inst|render_req.ADDR[1] render_inst|image_render_inst|render_req.ADDR[1]~24 render_inst|image_render_inst|render_req.ADDR[1]~25 render_inst|image_render_inst|render_req.ADDR[2] render_inst|image_render_inst|render_req.ADDR[2]~26 render_inst|image_render_inst|render_req.ADDR[2]~27 render_inst|image_render_inst|render_req.ADDR[3] render_inst|image_render_inst|render_req.ADDR[3]~28 render_inst|image_render_inst|render_req.ADDR[3]~29 render_inst|image_render_inst|render_req.ADDR[4] render_inst|image_render_inst|render_req.ADDR[4]~30 render_inst|image_render_inst|render_req.ADDR[4]~31 render_inst|image_render_inst|render_req.ADDR[5] render_inst|image_render_inst|render_req.ADDR[5]~32 render_inst|image_render_inst|render_req.ADDR[5]~33 render_inst|image_render_inst|render_req.ADDR[6] render_inst|image_render_inst|render_req.ADDR[6]~34 render_inst|image_render_inst|render_req.ADDR[6]~35 render_inst|image_render_inst|render_req.ADDR[7] render_inst|image_render_inst|render_req.ADDR[7]~36 render_inst|image_render_inst|render_req.ADDR[7]~37 render_inst|image_render_inst|render_req.ADDR[8] render_inst|image_render_inst|render_req.ADDR[8]~22 render_inst|image_render_inst|render_req.ADDR[8]~23 render_inst|image_render_inst|render_req.ADDR[8]~38 render_inst|image_render_inst|render_req.ADDR[8]~39 render_inst|image_render_inst|render_req.ADDR[9] render_inst|image_render_inst|render_req.ADDR[9]~40 render_inst|image_render_inst|render_req.ADDR[9]~41 render_inst|image_render_inst|render_req.ADDR[10] render_inst|image_render_inst|render_req.ADDR[10]~42 render_inst|image_render_inst|render_req.ADDR[10]~43 render_inst|image_render_inst|render_req.ADDR[11] render_inst|image_render_inst|render_req.ADDR[11]~44 render_inst|image_render_inst|render_req.ADDR[11]~45 render_inst|image_render_inst|render_req.ADDR[12] render_inst|image_render_inst|render_req.ADDR[12]~46 render_inst|image_render_inst|render_req.ADDR[12]~47 render_inst|image_render_inst|render_req.ADDR[13] render_inst|image_render_inst|render_req.ADDR[13]~48 render_inst|image_render_inst|render_req.ADDR[13]~49 render_inst|image_render_inst|render_req.ADDR[14] render_inst|image_render_inst|render_req.ADDR[14]~50 render_inst|image_render_inst|render_req.ADDR[14]~51 render_inst|image_render_inst|render_req.ADDR[15] render_inst|image_render_inst|render_req.ADDR[15]~52 render_inst|image_render_inst|render_req.ADDR[15]~53 render_inst|image_render_inst|render_req.ADDR[16] render_inst|image_render_inst|render_req.ADDR[16]~54 render_inst|image_render_inst|render_req.ADDR[16]~55 render_inst|image_render_inst|render_req.ADDR[17] render_inst|image_render_inst|render_req.ADDR[17]~56 render_inst|image_render_inst|render_req.ADDR[17]~57 render_inst|image_render_inst|render_req.ADDR[18] render_inst|image_render_inst|render_req.ADDR[18]~58 render_inst|image_render_inst|render_req.ADDR[18]~59 render_inst|image_render_inst|render_req.ADDR[19] render_inst|image_render_inst|render_req.ADDR[19]~60 render_inst|image_render_inst|render_req.WE_n vga_controller_inst|VGA_REQ.ADDR[19]~24 vga_controller_inst|VGA_REQ.ADDR[7]~0 vga_controller_inst|VGA_REQ.ADDR[7]~1 vga_controller_inst|VGA_REQ.ADDR[8]~2 vga_controller_inst|VGA_REQ.ADDR[8]~3 vga_controller_inst|VGA_REQ.ADDR[9]~4 vga_controller_inst|VGA_REQ.ADDR[9]~5 vga_controller_inst|VGA_REQ.ADDR[10]~6 vga_controller_inst|VGA_REQ.ADDR[10]~7 vga_controller_inst|VGA_REQ.ADDR[11]~8 vga_controller_inst|VGA_REQ.ADDR[11]~9 vga_controller_inst|VGA_REQ.ADDR[12]~10 vga_controller_inst|VGA_REQ.ADDR[12]~11 vga_controller_inst|VGA_REQ.ADDR[13]~12 vga_controller_inst|VGA_REQ.ADDR[13]~13 vga_controller_inst|VGA_REQ.ADDR[14]~14 vga_controller_inst|VGA_REQ.ADDR[14]~15 vga_controller_inst|VGA_REQ.ADDR[15]~16 vga_controller_inst|VGA_REQ.ADDR[15]~17 vga_controller_inst|VGA_REQ.ADDR[16]~18 vga_controller_inst|VGA_REQ.ADDR[16]~19 vga_controller_inst|VGA_REQ.ADDR[17]~20 vga_controller_inst|VGA_REQ.ADDR[17]~21 vga_controller_inst|VGA_REQ.ADDR[18]~22 vga_controller_inst|VGA_REQ.ADDR[18]~23}] -to [get_ports {RAM_ADDR[0]
 RAM_ADDR[1] RAM_ADDR[2] RAM_ADDR[3] RAM_ADDR[4] RAM_ADDR[5] RAM_ADDR[6] RAM_ADDR[7] RAM_ADDR[8] RAM_ADDR[9] RAM_ADDR[10] RAM_ADDR[11] RAM_ADDR[12] RAM_ADDR[13] RAM_ADDR[14] RAM_ADDR[15] RAM_ADDR[16] RAM_ADDR[17] RAM_ADDR[18] RAM_ADDR[19] RAM_CS_n RAM_DQ[0] RAM_DQ[1] RAM_DQ[2] RAM_DQ[3] RAM_DQ[4] RAM_DQ[5] RAM_DQ[6] RAM_DQ[7] RAM_DQ[8] RAM_DQ[9] RAM_DQ[10] RAM_DQ[11] RAM_DQ[12] RAM_DQ[13] RAM_DQ[14] RAM_DQ[15] RAM_DQ[16] RAM_DQ[17] RAM_DQ[18] RAM_DQ[19] RAM_DQ[20] RAM_DQ[21] RAM_DQ[22] RAM_DQ[23] RAM_DQ[24] RAM_DQ[25] RAM_DQ[26] RAM_DQ[27] RAM_DQ[28] RAM_DQ[29] RAM_DQ[30] RAM_DQ[31] RAM_OE_n RAM_WE_n}]
