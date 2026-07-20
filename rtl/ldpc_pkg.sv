//==============================================================
// File : rtl/ldpc_pkg.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

package ldpc_pkg;

    //----------------------------------------------------------
    // General Parameters
    //----------------------------------------------------------

    parameter int M = 10;
    parameter int N = 20;
    parameter int MAX_ITER = 10;
    parameter int LLR_W = 8;
    parameter int MAX_CN_DEG = 4;
    parameter int MAX_VN_DEG = 2;
    parameter int EDGE_COUNT = 40;

    //----------------------------------------------------------
    // Types
    //----------------------------------------------------------

    typedef logic signed [LLR_W-1:0] llr_t;
    typedef logic [N-1:0] codeword_t;
    typedef logic [M-1:0] syndrome_t;
    typedef logic [$clog2(MAX_CN_DEG)-1:0] cn_edge_t;
    typedef logic [$clog2(MAX_VN_DEG)-1:0] vn_edge_t;
    typedef logic [$clog2(MAX_ITER+1)-1:0] iter_t;

    //----------------------------------------------------------
    // FSM
    //----------------------------------------------------------

    typedef enum logic [2:0]{
        ST_RESET,
        ST_INIT,
        ST_CN_UPDATE,
        ST_VN_UPDATE,
        ST_SYNDROME,
        ST_DONE
    }
    state_t;

    //----------------------------------------------------------
    // Constants
    //----------------------------------------------------------

    localparam llr_t LLR_ZERO = '0;
    localparam llr_t LLR_MAX = 8'sd127;
    localparam llr_t LLR_MIN = -8'sd128;

    //----------------------------------------------------------
    // Saturation
    //----------------------------------------------------------

    function automatic llr_t sat_llr(
        input logic signed [15:0] value
    );

        if(value > LLR_MAX)			sat_llr = LLR_MAX;
        else if(value < LLR_MIN)	sat_llr = LLR_MIN;
        else						sat_llr = value[LLR_W-1:0];

    endfunction

    //----------------------------------------------------------
    // Absolute Value
    //----------------------------------------------------------

    function automatic llr_t abs_llr(
        input llr_t value
    );

        if(value[LLR_W-1])	abs_llr = -value;
        else				abs_llr = value;

    endfunction

    //----------------------------------------------------------
    // Sign
    //----------------------------------------------------------

    function automatic logic sign_llr(
        input llr_t value
    );

        sign_llr = value[LLR_W-1];

    endfunction

    //----------------------------------------------------------
    // Min
    //----------------------------------------------------------

    function automatic llr_t min_llr(
        input llr_t a,
        input llr_t b
    );

        if(a < b)	min_llr = a;
        else		min_llr = b;

    endfunction

    //----------------------------------------------------------
    // Max
    //----------------------------------------------------------

    function automatic llr_t max_llr
    (
        input llr_t a,
        input llr_t b
    );

        if(a > b)	max_llr = a;
        else		max_llr = b;

    endfunction

endpackage

`default_nettype wire
