//==============================================================
// File : sim/tb_ldpc_decoder.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module tb_ldpc_decoder;

    import ldpc_pkg::*;

    // Clock / Reset
    logic clk;
    logic rst;

    logic start;
    logic done;
    logic success;
    logic [N-1:0] decoded_bits;
    iter_t iter_count;

    // DUT
    ldpc_top dut
    (
        .clk(clk),
        .rst(rst),

        .start(start),
        .done(done),
        .success(success),
        .decoded_bits(decoded_bits),
        .iter_count(iter_count)
    );

    // Clock
    initial
    begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    // Test Sequence
    initial
    begin

        rst   = 1'b1;
        start = 1'b0;

        repeat(5)	@(posedge clk);

        rst = 1'b0;

        repeat(2)	@(posedge clk);

        start = 1'b1;

        @(posedge clk);

        start = 1'b0;

    end

    // Result Monitor
    initial
    begin

        wait(done);

        $display("--------------------------------");
        $display("LDPC DECODER FINISHED");
        $display("--------------------------------");
        $display("SUCCESS = %0d",success);
        $display("ITERATIONS = %0d",iter_count);
        $display("BITS = ");

        for(int i=0;i<N;i=i+1)	$write("%0d ",decoded_bits[i]);

        $display("");

        #50;

        $finish;

    end

    // Waveform

    initial
    begin

        $dumpfile("ldpc_decoder.vcd");
        $dumpvars(0,tb_ldpc_decoder);

    end

endmodule

`default_nettype wire
