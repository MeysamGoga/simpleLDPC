//==============================================================
// File : rtl/ldpc_top.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_top
(
    input  logic clk,
    input  logic rst,
	
    input  logic start,
    output logic done,
    output logic success,
    output logic [ldpc_pkg::N-1:0] decoded_bits,
    output ldpc_pkg::iter_t iter_count
);

    import ldpc_pkg::*;

    //----------------------------------------------------------
    // Decoder Instance
    //----------------------------------------------------------

    logic decoded_bits_array [N];

    ldpc_decoder u_decoder
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .success(success),
        .iter_count(iter_count),
        .decoded_bits(decoded_bits_array)
    );

    //----------------------------------------------------------
    // Convert unpacked to packed output
    //----------------------------------------------------------

    genvar i;
    generate
        for(i=0;i<N;i=i+1)
        begin
            assign decoded_bits[i] = decoded_bits_array[i];
        end
    endgenerate

endmodule

`default_nettype wire
