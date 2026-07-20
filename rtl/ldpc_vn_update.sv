//==============================================================
// File : rtl/ldpc_vn_update.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_vn_update
(
    input  logic clk,
    input  logic rst,

    input  logic start,
    output logic done,

    input  ldpc_pkg::llr_t channel_llr
        [ldpc_pkg::N],

    input  ldpc_pkg::llr_t cn_to_vn
        [ldpc_pkg::M][ldpc_pkg::MAX_CN_DEG],

    output ldpc_pkg::llr_t vn_to_cn
        [ldpc_pkg::M][ldpc_pkg::MAX_CN_DEG],

    output ldpc_pkg::llr_t app_llr
        [ldpc_pkg::N]
);

    import ldpc_pkg::*;
    import ldpc_h_matrix_pkg::*;

    integer vn;
    integer cn;
    integer k;
    integer edge;
    integer edge2;

    logic signed [15:0] sum;

    //----------------------------------------------------------
    // Find VN index inside one CN
    //----------------------------------------------------------

    function automatic int edge_index
    (
        input int cn_id,
        input int vn_id
    );

        int i;

        begin

            edge_index = -1;

            for(i=0;i<CN_DEGREE[cn_id];i=i+1)
            begin
                if(CN_CONN[cn_id][i]==vn_id)
                    edge_index=i;
            end

        end

    endfunction

    //----------------------------------------------------------

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            done <= 1'b0;

            for(vn=0;vn<N;vn=vn+1)
                app_llr[vn] <= '0;

            for(cn=0;cn<M;cn=cn+1)
                for(edge=0;edge<MAX_CN_DEG;edge=edge+1)
                    vn_to_cn[cn][edge] <= '0';

        end

        else
        begin

            done <= 1'b0;

            if(start)
            begin

                //--------------------------------------------------
                // APP LLR
                //--------------------------------------------------

                for(vn=0;vn<N;vn=vn+1)
                begin

                    sum = channel_llr[vn];

                    for(k=0;k<VN_DEGREE[vn];k=k+1)
                    begin

                        cn = VN_CONN[vn][k];

                        edge = edge_index(cn,vn);

                        sum += cn_to_vn[cn][edge];

                    end

                    app_llr[vn] <= sat_llr(sum);

                end

                //--------------------------------------------------
                // Extrinsic messages
                //--------------------------------------------------

                for(vn=0;vn<N;vn=vn+1)
                begin

                    for(k=0;k<VN_DEGREE[vn];k=k+1)
                    begin

                        cn = VN_CONN[vn][k];

                        edge = edge_index(cn,vn);

                        sum = channel_llr[vn];

                        for(int j=0;j<VN_DEGREE[vn];j=j+1)
                        begin

                            if(j!=k)
                            begin

                                edge2 = edge_index(
                                            VN_CONN[vn][j],
                                            vn
                                        );

                                sum += cn_to_vn
                                [
                                    VN_CONN[vn][j]
                                ]
                                [
                                    edge2
                                ];

                            end

                        end

                        vn_to_cn[cn][edge] <= sat_llr(sum);

                    end

                end

                done <= 1'b1;

            end

        end

    end

endmodule

`default_nettype wire
