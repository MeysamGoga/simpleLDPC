#==============================================================
# File : sim/run.do
#==============================================================

vlib work

vlog -sv ../rtl/ldpc_pkg.sv
vlog -sv ../rtl/ldpc_types.sv
vlog -sv ../rtl/ldpc_h_matrix.sv

vlog -sv ../rtl/ldpc_cn_update.sv
vlog -sv ../rtl/ldpc_vn_update.sv
vlog -sv ../rtl/ldpc_syndrome.sv
vlog -sv ../rtl/ldpc_fsm.sv
vlog -sv ../rtl/ldpc_decoder.sv
vlog -sv ../rtl/ldpc_top.sv

vlog -sv ./random_gaussian.sv
vlog -sv ./channel_awgn.sv
vlog -sv ./llr_quantizer.sv

vlog -sv ./tb_ldpc_decoder.sv

vsim -voptargs=+acc work.tb_ldpc_decoder

add wave -r sim:/tb_ldpc_decoder/*

run -all
