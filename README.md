# simpleLDPC

# LDPC Decoder FPGA (Plain Min-Sum)

## Status

Current Version:
v0.1

Algorithm:
Plain Min-Sum

Schedule:
Flooding

Target:
FPGA

Language:
SystemVerilog

------------------------------------------------------------

Directory

rtl/
    ldpc_pkg.sv
    ldpc_h_matrix.sv
    ldpc_cn_update.sv
    ldpc_vn_update.sv
    ldpc_syndrome.sv
    ldpc_fsm.sv
    ldpc_decoder.sv

sim/
    tb_ldpc_decoder.sv

------------------------------------------------------------

Compile Order

1.
ldpc_pkg.sv

2.
ldpc_h_matrix.sv

3.
ldpc_cn_update.sv

4.
ldpc_vn_update.sv

5.
ldpc_syndrome.sv

6.
ldpc_fsm.sv

7.
ldpc_decoder.sv

8.
tb_ldpc_decoder.sv

------------------------------------------------------------

Vivado

add_files rtl/*.sv

add_files sim/tb_ldpc_decoder.sv

Run Simulation

------------------------------------------------------------

Quartus

Create Project

Add RTL

Compile

Simulate

------------------------------------------------------------

Current Features

✓ Plain Min-Sum

✓ Flooding Schedule

✓ Fixed Point 8-bit

✓ Sparse H Matrix

✓ FSM

✓ Syndrome Check

✓ Hard Decision

✓ Testbench

------------------------------------------------------------

Next Version

Offset Min-Sum

Normalized Min-Sum

Layered Decoding

Pipeline

BRAM Mapping

AXI Interface

UART Input

External LLR

Large H Matrix

------------------------------------------------------------

Known Limitations

Current H matrix is only a placeholder.

Current channel values are fixed.

AWGN Generator is not connected yet.

Quantizer is not implemented.

No Pipeline.

No Resource Optimization.

No Timing Optimization.

------------------------------------------------------------

License

Educational / Research
