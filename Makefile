#==============================================================
# File : Makefile
#==============================================================

SIM ?= iverilog

RTL = \
rtl/ldpc_pkg.sv \
rtl/ldpc_h_matrix.sv \
rtl/ldpc_cn_update.sv \
rtl/ldpc_vn_update.sv \
rtl/ldpc_syndrome.sv \
rtl/ldpc_fsm.sv \
rtl/ldpc_decoder.sv

TB = \
sim/tb_ldpc_decoder.sv

OUT = build/ldpc_tb

all: sim

build:
	mkdir -p build

sim: build
	$(SIM) -g2012 -o $(OUT) $(RTL) $(TB)
	vvp $(OUT)

wave:
	gtkwave ldpc_decoder.vcd

clean:
	rm -rf build
	rm -f *.vcd
	rm -f *.fst
	rm -f *.log
	rm -f transcript
