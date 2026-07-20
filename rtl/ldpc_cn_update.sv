//==============================================================
// File : rtl/ldpc_cn_update.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_cn_update
(
    input  logic clk,
    input  logic rst,

    input  logic start,
    output logic done,
    input  ldpc_pkg::llr_t vn_to_cn [ldpc_pkg::M][ldpc_pkg::MAX_CN_DEG],
    output ldpc_pkg::llr_t cn_to_vn	[ldpc_pkg::M][ldpc_pkg::MAX_CN_DEG]
);

    import ldpc_pkg::*;

    integer cn;
    integer e;
    integer min_index;

    llr_t min1;
    llr_t min2;
    llr_t mag;

    logic parity_sign;
    logic out_sign;

    always_ff @(posedge clk or posedge rst) begin

        if(rst) begin
            done <= 1'b0;
            for(cn=0;cn<M;cn=cn+1)	for(e=0;e<MAX_CN_DEG;e=e+1)	cn_to_vn[cn][e] <= '0;

        end else begin
            done <= 1'b0;
            if(start) begin
                for(cn=0;cn<M;cn=cn+1) begin

                    // Find parity sign
                    parity_sign = 1'b0;

                    for(e=0;e<CN_DEGREE[cn];e=e+1)
                        parity_sign ^= sign_llr(vn_to_cn[cn][e]);

                    // Find first and second minimum
                    min1 = LLR_MAX;
                    min2 = LLR_MAX;
                    min_index = 0;

                    for(e=0;e<CN_DEGREE[cn];e=e+1) begin
                        mag = abs_llr(vn_to_cn[cn][e]);
                        if(mag < min1) begin		min2 = min1;
                            min1 = mag;
                            min_index = e;
                        end
                        else if(mag < min2) begin	min2 = mag;	end

                    end

                    // Generate CN messages
                    for(e=0;e<CN_DEGREE[cn];e=e+1) begin
                        if(e == min_index)	mag = min2;
                        else				mag = min1;
                        out_sign = parity_sign ^ sign_llr(vn_to_cn[cn][e]);
                        if(out_sign)	cn_to_vn[cn][e] <= -mag;
                        else			cn_to_vn[cn][e] <= mag;
                    end
                end
                done <= 1'b1;
            end
        end
    end

endmodule

`default_nettype wire
