//==============================================================
// File : sim/channel_awgn.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module channel_awgn
(
    input  logic clk,

    input  logic enable,

    input  logic tx_bit,

    output real channel_output
);

    real noise;
    real sigma;

    initial
    begin
        sigma = 0.7;
    end


    always @(posedge clk)
    begin

        if(enable)
        begin

            if(tx_bit == 1'b0)
                channel_output = 1.0;
            else
                channel_output = -1.0;


            noise = $itor($urandom_range(0,10000))/10000.0;

            noise = (noise-0.5)*2.0*sigma;


            channel_output =
                channel_output + noise;

        end

    end

endmodule

`default_nettype wire
