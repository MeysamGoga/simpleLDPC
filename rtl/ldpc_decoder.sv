//==============================================================
// File : rtl/ldpc_decoder.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_decoder
(
    input  logic clk,
    input  logic rst,

    input  logic start,

    output logic done,
    output logic success,

    output logic [3:0] iter_count,

    output logic hard_bits
        [ldpc_pkg::N]
);

    import ldpc_pkg::*;
    import ldpc_h_matrix_pkg::*;

    //----------------------------------------------------------
    // Internal Memories
    //----------------------------------------------------------

    llr_t channel_llr [N];
    llr_t app_llr     [N];

    llr_t vn_to_cn [M][MAX_CN_DEG];
    llr_t cn_to_vn [M][MAX_CN_DEG];

    //----------------------------------------------------------
    // FSM Signals
    //----------------------------------------------------------

    logic init_en;

    logic cn_start;
    logic vn_start;
    logic syndrome_start;

    logic cn_done;
    logic vn_done;
    logic syndrome_done;

    //----------------------------------------------------------
    // Initialization
    //----------------------------------------------------------

    integer i;
    integer j;

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            for(i=0;i<N;i=i+1)
                channel_llr[i] <= '0;

        end

        else if(init_en)
        begin

            //--------------------------------------------------
            // Temporary Fixed LLR
            // (Simulation values)
            //--------------------------------------------------

            channel_llr[ 0] <=  8'sd42;
            channel_llr[ 1] <=  8'sd38;
            channel_llr[ 2] <=  8'sd35;
            channel_llr[ 3] <=  8'sd51;
            channel_llr[ 4] <=  8'sd29;

            channel_llr[ 5] <=  8'sd41;
            channel_llr[ 6] <=  8'sd36;
            channel_llr[ 7] <=  8'sd47;
            channel_llr[ 8] <=  8'sd32;
            channel_llr[ 9] <=  8'sd44;

            channel_llr[10] <=  8'sd40;
            channel_llr[11] <=  8'sd39;
            channel_llr[12] <=  8'sd34;
            channel_llr[13] <=  8'sd48;
            channel_llr[14] <=  8'sd43;

            channel_llr[15] <=  8'sd46;
            channel_llr[16] <=  8'sd31;
            channel_llr[17] <=  8'sd37;
            channel_llr[18] <=  8'sd45;
            channel_llr[19] <=  8'sd33;

            for(i=0;i<M;i=i+1)
            begin

                for(j=0;j<MAX_CN_DEG;j=j+1)
                begin

                    vn_to_cn[i][j] <= '0;
                    cn_to_vn[i][j] <= '0;

                end

            end

        end

    end

    //----------------------------------------------------------
    // Check Node Engine
    //----------------------------------------------------------

    ldpc_cn_update u_cn
    (
        .clk(clk),
        .rst(rst),

        .start(cn_start),
        .done(cn_done),

        .vn_to_cn(vn_to_cn),
        .cn_to_vn(cn_to_vn)
    );

    //----------------------------------------------------------
    // Variable Node Engine
    //----------------------------------------------------------

    ldpc_vn_update u_vn
    (
        .clk(clk),
        .rst(rst),

        .start(vn_start),
        .done(vn_done),

        .channel_llr(channel_llr),

        .cn_to_vn(cn_to_vn),

        .vn_to_cn(vn_to_cn),

        .app_llr(app_llr)
    );

    //----------------------------------------------------------
    // Syndrome Checker
    //----------------------------------------------------------

    ldpc_syndrome u_syn
    (
        .clk(clk),
        .rst(rst),

        .start(syndrome_start),

        .app_llr(app_llr),

        .done(syndrome_done),

        .success(success),

        .hard_bits(hard_bits)
    );

    //----------------------------------------------------------
    // FSM
    //----------------------------------------------------------

    ldpc_fsm u_fsm
    (
        .clk(clk),
        .rst(rst),

        .start(start),

        .cn_done(cn_done),
        .vn_done(vn_done),
        .syndrome_done(syndrome_done),

        .success(success),

        .init_en(init_en),

        .cn_start(cn_start),
        .vn_start(vn_start),
        .syndrome_start(syndrome_start),

        .done(done),

        .iter_count(iter_count)
    );

endmodule

`default_nettype wire
