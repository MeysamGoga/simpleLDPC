//==============================================================
// File : rtl/ldpc_syndrome.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_syndrome
(
    input  logic clk,
    input  logic rst,

    input  logic start,

    input  logic signed [7:0] app_llr
        [ldpc_pkg::N],

    output logic done,
    output logic success,

    output logic hard_bits
        [ldpc_pkg::N]
);

    import ldpc_pkg::*;
    import ldpc_h_matrix_pkg::*;

    integer vn;
    integer cn;
    integer e;

    logic parity;

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            done    <= 1'b0;
            success <= 1'b0;

            for(vn=0;vn<N;vn=vn+1)
                hard_bits[vn] <= 1'b0;
        end

        else
        begin

            done <= 1'b0;

            if(start)
            begin

                //--------------------------------------------------
                // Hard Decision
                //--------------------------------------------------

                for(vn=0;vn<N;vn=vn+1)
                begin
                    hard_bits[vn] <= app_llr[vn][LLR_W-1];
                end

                //--------------------------------------------------
                // Syndrome
                //--------------------------------------------------

                success = 1'b1;

                for(cn=0;cn<M;cn=cn+1)
                begin

                    parity = 1'b0;

                    for(e=0;e<CN_DEGREE[cn];e=e+1)
                    begin

                        parity ^= hard_bits[ CN_CONN[cn][e] ];

                    end

                    if(parity)
                        success = 1'b0;

                end

                done <= 1'b1;

            end

        end

    end

endmodule

`default_nettype wire
