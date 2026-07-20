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
    integer edge;
    integer cn;
    integer k;

    logic signed [15:0] sum;

    function automatic int find_edge
    (
        input int cn_id,
        input int vn_id
    );

        integer i;

        begin

            find_edge = -1;

            for(i=0;i<MAX_CN_DEG;i=i+1)
            begin

                if(CN_CONN[cn_id][i]==vn_id)
                    find_edge=i;

            end

        end

    endfunction

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            done <= 1'b0;

            for(vn=0;vn<N;vn=vn+1)
                app_llr[vn] <= '0;

            for(cn=0;cn<M;cn=cn+1)
                for(edge=0;edge<MAX_CN_DEG;edge=edge+1)
                    vn_to_cn[cn][edge] <= '0;

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

                        edge = find_edge(cn,vn);

                        if(edge!=-1)
                            sum = sum + cn_to_vn[cn][edge];

                    end

                    app_llr[vn] <= sat8(sum);

                end

                //--------------------------------------------------
                // Extrinsic Messages
                //--------------------------------------------------

                for(vn=0;vn<N;vn=vn+1)
                begin

                    for(k=0;k<VN_DEGREE[vn];k=k+1)
                    begin

                        cn = VN_CONN[vn][k];

                        edge = find_edge(cn,vn);

                        sum = channel_llr[vn];

                        for(integer j=0;
                            j<VN_DEGREE[vn];
                            j=j+1)
                        begin

                            integer cn2;
                            integer edge2;

                            cn2 = VN_CONN[vn][j];

                            edge2 = find_edge(cn2,vn);

                            if(j!=k)
                                sum = sum + cn_to_vn[cn2][edge2];

                        end

                        vn_to_cn[cn][edge] <= sat8(sum);

                    end

                end

                done <= 1'b1;

            end

        end

    end

endmodule

`default_nettype wire
