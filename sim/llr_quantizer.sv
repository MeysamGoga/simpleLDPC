//==============================================================
// File : sim/llr_quantizer.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module llr_quantizer
(
    input  real channel_value,
    output logic signed [7:0] llr
);

    real scale;
    integer temp;

    initial begin
        scale = 32.0;
    end

    always @(*) begin

        temp = $rtoi(channel_value * scale);

        if(temp > 127)			llr = 8'sd127;
        else if(temp < -128)	llr = -8'sd128;
        else					llr = temp[7:0];

    end

endmodule

`default_nettype wire
