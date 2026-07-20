#==============================================================
# File : vivado/create_project.tcl
#==============================================================

set PROJECT_NAME ldpc_fpga
set PART xc7a35tcpg236-1

create_project $PROJECT_NAME ./$PROJECT_NAME -part $PART -force

#--------------------------------------------------------------
# RTL
#--------------------------------------------------------------

add_files ./rtl/ldpc_pkg.sv
add_files ./rtl/ldpc_h_matrix.sv
add_files ./rtl/ldpc_cn_update.sv
add_files ./rtl/ldpc_vn_update.sv
add_files ./rtl/ldpc_syndrome.sv
add_files ./rtl/ldpc_fsm.sv
add_files ./rtl/ldpc_decoder.sv

#--------------------------------------------------------------
# Simulation
#--------------------------------------------------------------

add_files -fileset sim_1 ./sim/tb_ldpc_decoder.sv

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property top ldpc_decoder [current_fileset]
set_property top tb_ldpc_decoder [get_filesets sim_1]

save_project_as $PROJECT_NAME ./$PROJECT_NAME

puts ""
puts "----------------------------------------"
puts " Project Created Successfully"
puts "----------------------------------------"
puts ""
