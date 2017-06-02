## Generated SDC file "cfpga.out.sdc"

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

## DATE    "Wed May 24 09:07:55 2017"

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

create_clock -name {clk} -period 3.000 -waveform { 0.000 1.500 } [get_ports {CE_MEMORY_OE}]


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

set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[0]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[1]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[2]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[3]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[4]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[5]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[6]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[7]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[8]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[9]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[10]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[11]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[12]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[13]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[14]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[15]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[16]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[17]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[18]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_ADDR[19]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_CE}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[0]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[1]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[2]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[3]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[4]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[5]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[6]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[7]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[8]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[9]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[10]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[11]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[12]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[13]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[14]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[15]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[16]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[17]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[18]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[19]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[20]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[21]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[22]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[23]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[24]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[25]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[26]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[27]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[28]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[29]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[30]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_DATA[31]}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_OE}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {CE_MEMORY_WE}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[13]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[14]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[15]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[16]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[17]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[18]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMADDR[19]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMCE}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[8]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[9]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[10]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[11]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[12]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[13]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[14]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[15]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[16]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[17]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[18]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[19]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[20]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[21]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[22]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[23]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[24]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[25]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[26]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[27]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[28]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[29]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[30]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMDATA[31]}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMOE}]
set_output_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {BASERAMWE}]


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

set_max_delay -from [get_pins {CE_MEMORY_ADDR[0]|combout CE_MEMORY_ADDR[1]|combout CE_MEMORY_ADDR[2]|combout CE_MEMORY_ADDR[3]|combout CE_MEMORY_ADDR[4]|combout CE_MEMORY_ADDR[5]|combout CE_MEMORY_ADDR[6]|combout CE_MEMORY_ADDR[7]|combout CE_MEMORY_ADDR[8]|combout CE_MEMORY_ADDR[9]|combout CE_MEMORY_ADDR[10]|combout CE_MEMORY_ADDR[11]|combout CE_MEMORY_ADDR[12]|combout CE_MEMORY_ADDR[13]|combout CE_MEMORY_ADDR[14]|combout CE_MEMORY_ADDR[15]|combout CE_MEMORY_ADDR[16]|combout CE_MEMORY_ADDR[17]|combout CE_MEMORY_ADDR[18]|combout CE_MEMORY_ADDR[19]|combout CE_MEMORY_CE|combout CE_MEMORY_DATA[0]|combout CE_MEMORY_DATA[0]|datain CE_MEMORY_DATA[0]|oe CE_MEMORY_DATA[1]|combout CE_MEMORY_DATA[1]|datain CE_MEMORY_DATA[1]|oe CE_MEMORY_DATA[2]|combout CE_MEMORY_DATA[2]|datain CE_MEMORY_DATA[2]|oe CE_MEMORY_DATA[3]|combout CE_MEMORY_DATA[3]|datain CE_MEMORY_DATA[3]|oe CE_MEMORY_DATA[4]|combout CE_MEMORY_DATA[4]|datain CE_MEMORY_DATA[4]|oe CE_MEMORY_DATA[5]|combout CE_MEMORY_DATA[5]|datain CE_MEMORY_DATA[5]|oe CE_MEMORY_DATA[6]|combout CE_MEMORY_DATA[6]|datain CE_MEMORY_DATA[6]|oe CE_MEMORY_DATA[7]|combout CE_MEMORY_DATA[7]|datain CE_MEMORY_DATA[7]|oe CE_MEMORY_DATA[8]|combout CE_MEMORY_DATA[8]|datain CE_MEMORY_DATA[8]|oe CE_MEMORY_DATA[9]|combout CE_MEMORY_DATA[9]|datain CE_MEMORY_DATA[9]|oe CE_MEMORY_DATA[10]|combout CE_MEMORY_DATA[10]|datain CE_MEMORY_DATA[10]|oe CE_MEMORY_DATA[11]|combout CE_MEMORY_DATA[11]|datain CE_MEMORY_DATA[11]|oe CE_MEMORY_DATA[12]|combout CE_MEMORY_DATA[12]|datain CE_MEMORY_DATA[12]|oe CE_MEMORY_DATA[13]|combout CE_MEMORY_DATA[13]|datain CE_MEMORY_DATA[13]|oe CE_MEMORY_DATA[14]|combout CE_MEMORY_DATA[14]|datain CE_MEMORY_DATA[14]|oe CE_MEMORY_DATA[15]|combout CE_MEMORY_DATA[15]|datain CE_MEMORY_DATA[15]|oe CE_MEMORY_DATA[16]|combout CE_MEMORY_DATA[16]|datain CE_MEMORY_DATA[16]|oe CE_MEMORY_DATA[17]|combout CE_MEMORY_DATA[17]|datain CE_MEMORY_DATA[17]|oe CE_MEMORY_DATA[18]|combout CE_MEMORY_DATA[18]|datain CE_MEMORY_DATA[18]|oe CE_MEMORY_DATA[19]|combout CE_MEMORY_DATA[19]|datain CE_MEMORY_DATA[19]|oe CE_MEMORY_DATA[20]|combout CE_MEMORY_DATA[20]|datain CE_MEMORY_DATA[20]|oe CE_MEMORY_DATA[21]|combout CE_MEMORY_DATA[21]|datain CE_MEMORY_DATA[21]|oe CE_MEMORY_DATA[22]|combout CE_MEMORY_DATA[22]|datain CE_MEMORY_DATA[22]|oe CE_MEMORY_DATA[23]|combout CE_MEMORY_DATA[23]|datain CE_MEMORY_DATA[23]|oe CE_MEMORY_DATA[24]|combout CE_MEMORY_DATA[24]|datain CE_MEMORY_DATA[24]|oe CE_MEMORY_DATA[25]|combout CE_MEMORY_DATA[25]|datain CE_MEMORY_DATA[25]|oe CE_MEMORY_DATA[26]|combout CE_MEMORY_DATA[26]|datain CE_MEMORY_DATA[26]|oe CE_MEMORY_DATA[27]|combout CE_MEMORY_DATA[27]|datain CE_MEMORY_DATA[27]|oe CE_MEMORY_DATA[28]|combout CE_MEMORY_DATA[28]|datain CE_MEMORY_DATA[28]|oe CE_MEMORY_DATA[29]|combout CE_MEMORY_DATA[29]|datain CE_MEMORY_DATA[29]|oe CE_MEMORY_DATA[30]|combout CE_MEMORY_DATA[30]|datain CE_MEMORY_DATA[30]|oe CE_MEMORY_DATA[31]|combout CE_MEMORY_DATA[31]|datain CE_MEMORY_DATA[31]|oe CE_MEMORY_OE|combout CE_MEMORY_WE|combout}] -to [get_pins {BASERAMADDR[0]|datain BASERAMADDR[1]|datain BASERAMADDR[2]|datain BASERAMADDR[3]|datain BASERAMADDR[4]|datain BASERAMADDR[5]|datain BASERAMADDR[6]|datain BASERAMADDR[7]|datain BASERAMADDR[8]|datain BASERAMADDR[9]|datain BASERAMADDR[10]|datain BASERAMADDR[11]|datain BASERAMADDR[12]|datain BASERAMADDR[13]|datain BASERAMADDR[14]|datain BASERAMADDR[15]|datain BASERAMADDR[16]|datain BASERAMADDR[17]|datain BASERAMADDR[18]|datain BASERAMADDR[19]|datain BASERAMCE|datain BASERAMDATA[0]|combout BASERAMDATA[0]|datain BASERAMDATA[0]|oe BASERAMDATA[1]|combout BASERAMDATA[1]|datain BASERAMDATA[1]|oe BASERAMDATA[2]|combout BASERAMDATA[2]|datain BASERAMDATA[2]|oe BASERAMDATA[3]|combout BASERAMDATA[3]|datain BASERAMDATA[3]|oe BASERAMDATA[4]|combout BASERAMDATA[4]|datain BASERAMDATA[4]|oe BASERAMDATA[5]|combout BASERAMDATA[5]|datain BASERAMDATA[5]|oe BASERAMDATA[6]|combout BASERAMDATA[6]|datain BASERAMDATA[6]|oe BASERAMDATA[7]|combout BASERAMDATA[7]|datain BASERAMDATA[7]|oe BASERAMDATA[8]|combout BASERAMDATA[8]|datain BASERAMDATA[8]|oe BASERAMDATA[9]|combout BASERAMDATA[9]|datain BASERAMDATA[9]|oe BASERAMDATA[10]|combout BASERAMDATA[10]|datain BASERAMDATA[10]|oe BASERAMDATA[11]|combout BASERAMDATA[11]|datain BASERAMDATA[11]|oe BASERAMDATA[12]|combout BASERAMDATA[12]|datain BASERAMDATA[12]|oe BASERAMDATA[13]|combout BASERAMDATA[13]|datain BASERAMDATA[13]|oe BASERAMDATA[14]|combout BASERAMDATA[14]|datain BASERAMDATA[14]|oe BASERAMDATA[15]|combout BASERAMDATA[15]|datain BASERAMDATA[15]|oe BASERAMDATA[16]|combout BASERAMDATA[16]|datain BASERAMDATA[16]|oe BASERAMDATA[17]|combout BASERAMDATA[17]|datain BASERAMDATA[17]|oe BASERAMDATA[18]|combout BASERAMDATA[18]|datain BASERAMDATA[18]|oe BASERAMDATA[19]|combout BASERAMDATA[19]|datain BASERAMDATA[19]|oe BASERAMDATA[20]|combout BASERAMDATA[20]|datain BASERAMDATA[20]|oe BASERAMDATA[21]|combout BASERAMDATA[21]|datain BASERAMDATA[21]|oe BASERAMDATA[22]|combout BASERAMDATA[22]|datain BASERAMDATA[22]|oe BASERAMDATA[23]|combout BASERAMDATA[23]|datain BASERAMDATA[23]|oe BASERAMDATA[24]|combout BASERAMDATA[24]|datain BASERAMDATA[24]|oe BASERAMDATA[25]|combout BASERAMDATA[25]|datain BASERAMDATA[25]|oe BASERAMDATA[26]|combout BASERAMDATA[26]|datain BASERAMDATA[26]|oe BASERAMDATA[27]|combout BASERAMDATA[27]|datain BASERAMDATA[27]|oe BASERAMDATA[28]|combout BASERAMDATA[28]|datain BASERAMDATA[28]|oe BASERAMDATA[29]|combout BASERAMDATA[29]|datain BASERAMDATA[29]|oe BASERAMDATA[30]|combout BASERAMDATA[30]|datain BASERAMDATA[30]|oe BASERAMDATA[31]|combout BASERAMDATA[31]|datain BASERAMDATA[31]|oe BASERAMOE|datain BASERAMWE|datain}] 3.000


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

