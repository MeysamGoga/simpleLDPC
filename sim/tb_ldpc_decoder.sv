//==============================================================
// File : sim/tb_ldpc_decoder.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module tb_ldpc_decoder;

    import ldpc_pkg::*;

    //----------------------------------------------------------
    // Clock / Reset
    //----------------------------------------------------------

    logic clk;
    logic rst;

    logic start;

    logic done;
    logic success;

    logic [3:0] iter_count;

    logic hard_bits[N];

    //----------------------------------------------------------
    // DUT
    //----------------------------------------------------------

    ldpc_decoder dut
    (
        .clk(clk),
        .rst(rst),

        .start(start),

        .done(done),
        .success(success),

        .iter_count(iter_count),

        .hard_bits(hard_bits)
    );

    //----------------------------------------------------------
    // Clock
    //----------------------------------------------------------

    initial
    begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //----------------------------------------------------------
    // Reset
    //----------------------------------------------------------

    initial
    begin

        rst   = 1'b1;
        start = 1'b0;

        repeat(10) @(posedge clk);

        rst = 1'b0;

        repeat(2) @(posedge clk);

        start = 1'b1;

        @(posedge clk);

        start = 1'b0;

    end

    //----------------------------------------------------------
    // Wait
    //----------------------------------------------------------

    initial
    begin

        wait(done);

        $display("-------------------------------------");
        $display("LDPC Decode Finished");
        $display("-------------------------------------");

        if(success)
            $display("Decode SUCCESS");
        else
            $display("Decode FAILED");

        $display("Iterations = %0d",iter_count);

        $display("");

        $display("Decoded Bits");

        for(int i=0;i<N;i++)
        begin

            $write("%0d ",hard_bits[i]);

        end

        $display("");

        repeat(20) @(posedge clk);

        $finish;

    end

    //----------------------------------------------------------
    // Monitor
    //----------------------------------------------------------

    initial
    begin

        $display("");
        $display("=========================================");
        $display(" LDPC Decoder Simulation");
        $display("=========================================");
        $display("");

        $monitor(
            "T=%0t start=%0b done=%0b success=%0b iter=%0d",
            $time,
            start,
            done,
            success,
            iter_count
        );

    end

    //----------------------------------------------------------
    // Waveform
    //----------------------------------------------------------

    initial
    begin

        $dumpfile("ldpc_decoder.vcd");
        $dumpvars(0,tb_ldpc_decoder);

    end

endmodule

`default_nettype wire
