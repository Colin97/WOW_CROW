## Generated SDC file "wow_crow.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Fri May 26 11:34:17 2017"

##
## DEVICE  "EP2C70F672C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {freq_div:freq_div_25m_inst|output} -period 1.000 -waveform { 0.000 0.500 } [get_registers {freq_div:freq_div_25m_inst|output}]
create_clock -name {CLK} -period 1.000 -waveform { 0.000 0.500 } [get_ports {CLK}]
create_clock -name {freq_div:freq_div_1000_inst|output} -period 1.000 -waveform { 0.000 0.500 } [get_registers {freq_div:freq_div_1000_inst|output}]
create_clock -name {clk25m} -period 40.000 -waveform { 0.000 20.000 } [get_nets {freq_div_25m_inst|output}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[13]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[14]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[15]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[16]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[17]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[18]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_ADDR[19]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[0]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[1]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[2]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[3]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[4]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[5]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[6]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[7]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[8]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[9]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[10]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[11]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[12]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[13]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[14]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[15]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[16]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[17]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[18]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[19]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[20]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[21]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[22]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[23]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[24]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[25]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[26]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[27]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[28]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[29]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[30]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_DQ[31]}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_OE_n}]
set_output_delay -add_delay -max -clock [get_clocks {freq_div:freq_div_25m_inst|output}]  8.000 [get_ports {RAM_WE_n}]


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

