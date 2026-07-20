#==============================================================
# File : vivado/build.tcl
#==============================================================

set PROJECT_NAME ldpc_fpga

set PROJECT_DIR "./$PROJECT_NAME"

set DEVICE xc7a35tcpg236-1


create_project $PROJECT_NAME $PROJECT_DIR \
    -part $DEVICE \
    -force


#--------------------------------------------------------------
# RTL Sources
#--------------------------------------------------------------

add_files ../rtl/ldpc_pkg.sv
add_files ../rtl/ldpc_types.sv
add_files ../rtl/ldpc_h_matrix.sv

add_files ../rtl/ldpc_cn_update.sv
add_files ../rtl/ldpc_vn_update.sv
add_files ../rtl/ldpc_syndrome.sv
add_files ../rtl/ldpc_fsm.sv

add_files ../rtl/ldpc_decoder.sv
add_files ../rtl/ldpc_top.sv


#--------------------------------------------------------------
# Simulation Sources
#--------------------------------------------------------------

add_files -fileset sim_1 ../sim/tb_ldpc_decoder.sv

add_files -fileset sim_1 ../sim/random_gaussian.sv
add_files -fileset sim_1 ../sim/channel_awgn.sv
add_files -fileset sim_1 ../sim/llr_quantizer.sv


#--------------------------------------------------------------
# Top Module
#--------------------------------------------------------------

set_property top ldpc_top [current_fileset]


#--------------------------------------------------------------
# Simulation Top
#--------------------------------------------------------------

set_property top tb_ldpc_decoder \
    [get_filesets sim_1]


#--------------------------------------------------------------
# Compile Order
#--------------------------------------------------------------

update_compile_order -fileset sources_1

update_compile_order -fileset sim_1


#--------------------------------------------------------------
# Synthesis
#--------------------------------------------------------------

launch_runs synth_1

wait_on_run synth_1


#--------------------------------------------------------------
# Implementation
#--------------------------------------------------------------

launch_runs impl_1

wait_on_run impl_1


#--------------------------------------------------------------
# Bitstream
#--------------------------------------------------------------

launch_runs impl_1 -to_step write_bitstream

wait_on_run impl_1


puts "====================================="
puts " LDPC FPGA BUILD COMPLETE "
puts "====================================="
