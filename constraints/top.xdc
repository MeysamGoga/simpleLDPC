//==============================================================
// File : constraints/top.xdc
// Target : AMD Xilinx Alveo U55C
// Device : XCU55C-FSVH2892-2L-E
//==============================================================


#--------------------------------------------------------------
# Clock
# Alveo U55C 100 MHz system clock
#--------------------------------------------------------------

create_clock -period 10.000 \
    -name sys_clk \
    [get_ports clk]


set_property CLOCK_DEDICATED_ROUTE FALSE \
    [get_nets clk]


#--------------------------------------------------------------
# Reset
#--------------------------------------------------------------

set_property IOSTANDARD LVCMOS18 \
    [get_ports rst]


#--------------------------------------------------------------
# Start Input
#--------------------------------------------------------------

set_property IOSTANDARD LVCMOS18 \
    [get_ports start]


#--------------------------------------------------------------
# Decoder Outputs
#--------------------------------------------------------------

set_property IOSTANDARD LVCMOS18 \
    [get_ports done]

set_property IOSTANDARD LVCMOS18 \
    [get_ports success]


#--------------------------------------------------------------
# Decoded Bits
# 20 bit output bus
#--------------------------------------------------------------

set_property IOSTANDARD LVCMOS18 \
    [get_ports {decoded_bits[*]}]


#--------------------------------------------------------------
# Iteration Counter
#--------------------------------------------------------------

set_property IOSTANDARD LVCMOS18 \
    [get_ports {iter_count[*]}]


#--------------------------------------------------------------
# Timing Constraints
#--------------------------------------------------------------

set_input_delay -clock sys_clk 2.0 \
    [get_ports start]

set_input_delay -clock sys_clk 2.0 \
    [get_ports rst]


set_output_delay -clock sys_clk 2.0 \
    [get_ports done]

set_output_delay -clock sys_clk 2.0 \
    [get_ports success]

set_output_delay -clock sys_clk 2.0 \
    [get_ports {decoded_bits[*]}]


#--------------------------------------------------------------
# False Paths
#--------------------------------------------------------------

set_false_path \
    -from [get_ports rst]


#--------------------------------------------------------------
# Max Fanout
#--------------------------------------------------------------

set_property MAX_FANOUT 100 \
    [get_nets]


#==============================================================
# End
#==============================================================
