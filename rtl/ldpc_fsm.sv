//==============================================================
// File : rtl/ldpc_fsm.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

module ldpc_fsm
(
    input  logic clk,
    input  logic rst,

    input  logic start,

    input  logic cn_done,
    input  logic vn_done,
    input  logic syndrome_done,
    input  logic success,

    output logic init_en,
    output logic cn_start,
    output logic vn_start,
    output logic syndrome_start,

    output logic done,
    output logic [3:0] iter_count
);

    import ldpc_pkg::*;

    state_t state;
    state_t next_state;

    logic [3:0] iter_reg;

    //----------------------------------------------------------
    // State Register
    //----------------------------------------------------------

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin
            state    <= ST_RESET;
            iter_reg <= '0;
        end
        else
        begin
            state <= next_state;

            if(state == ST_INIT)
                iter_reg <= 4'd0;

            else if(state == ST_SYNDROME && syndrome_done && !success)
                iter_reg <= iter_reg + 4'd1;
        end

    end

    //----------------------------------------------------------
    // Outputs
    //----------------------------------------------------------

    always_comb
    begin

        init_en         = 1'b0;
        cn_start        = 1'b0;
        vn_start        = 1'b0;
        syndrome_start  = 1'b0;
        done            = 1'b0;

        next_state = state;

        case(state)

            //--------------------------------------------------

            ST_RESET:
            begin

                if(start)
                    next_state = ST_INIT;

            end

            //--------------------------------------------------

            ST_INIT:
            begin

                init_en = 1'b1;

                next_state = ST_CN_UPDATE;

            end

            //--------------------------------------------------

            ST_CN_UPDATE:
            begin

                cn_start = 1'b1;

                if(cn_done)
                    next_state = ST_VN_UPDATE;

            end

            //--------------------------------------------------

            ST_VN_UPDATE:
            begin

                vn_start = 1'b1;

                if(vn_done)
                    next_state = ST_SYNDROME;

            end

            //--------------------------------------------------

            ST_SYNDROME:
            begin

                syndrome_start = 1'b1;

                if(syndrome_done)
                begin

                    if(success)
                        next_state = ST_DONE;

                    else if(iter_reg == (MAX_ITER-1))
                        next_state = ST_DONE;

                    else
                        next_state = ST_CN_UPDATE;

                end

            end

            //--------------------------------------------------

            ST_DONE:
            begin

                done = 1'b1;

                if(!start)
                    next_state = ST_RESET;

            end

            //--------------------------------------------------

            default:
            begin

                next_state = ST_RESET;

            end

        endcase

    end

    //----------------------------------------------------------

    assign iter_count = iter_reg;

endmodule

`default_nettype wire
