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

    output logic init,
    output logic cn_start,
    output logic vn_start,
    output logic syndrome_start,

    output logic done,
    output ldpc_pkg::iter_t iter_count
);

    import ldpc_pkg::*;

    state_t state;
    state_t next_state;
    iter_t iter;

    // State Register
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin				iter  <= '0;	state <= ST_RESET;
        end else begin								state <= next_state;

            if(state == ST_INIT)	iter <= '0;
            else if(state == ST_SYNDROME && syndrome_done && !success)
									iter <= iter + 1'b1;
        end
    end

    // Next-State Logic
    always_comb
    begin

        init            = 1'b0;
        cn_start        = 1'b0;
        vn_start        = 1'b0;
        syndrome_start  = 1'b0;
        done            = 1'b0;

        next_state = state;

        case(state)

            ST_RESET:		begin
                if(start)							next_state = ST_INIT;
            end

            ST_INIT:		begin	init = 1'b1;	next_state = ST_CN_UPDATE;
            end

            ST_CN_UPDATE:	begin	cn_start = 1'b1;
                if(cn_done)							next_state = ST_VN_UPDATE;
            end

            ST_VN_UPDATE:	begin	vn_start = 1'b1;
                if(vn_done)							next_state = ST_SYNDROME;
            end

            ST_SYNDROME:	begin	syndrome_start = 1'b1;

                if(syndrome_done) begin
                    if(success)						next_state = ST_DONE;
                    else if(iter >= (MAX_ITER-1))	next_state = ST_DONE;
                    else                        	next_state = ST_CN_UPDATE;
                end
            end

            ST_DONE:		begin	done = 1'b1;
                if(!start)							next_state = ST_RESET;
            end

            default:		begin					next_state = ST_RESET;
            end

        endcase

    end

    assign iter_count = iter;

endmodule

`default_nettype wire
