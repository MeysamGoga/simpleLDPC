//==============================================================
// File : rtl/ldpc_types.sv
//==============================================================

`timescale 1ns/1ps
`default_nettype none

package ldpc_types_pkg;

    import ldpc_pkg::*;

    //----------------------------------------------------------
    // Basic Arrays
    //----------------------------------------------------------

    typedef llr_t llr_vector_t [N];

    typedef logic bit_vector_t [N];

    typedef llr_t app_llr_t [N];

    typedef logic syndrome_vector_t [M];

    //----------------------------------------------------------
    // Message Memories
    //----------------------------------------------------------

    typedef llr_t vn_to_cn_mem_t [M][MAX_CN_DEG];

    typedef llr_t cn_to_vn_mem_t [M][MAX_CN_DEG];

    //----------------------------------------------------------
    // Channel Memory
    //----------------------------------------------------------

    typedef llr_t channel_mem_t [N];

    //----------------------------------------------------------
    // Degree Tables
    //----------------------------------------------------------

    typedef int cn_degree_t [M];

    typedef int vn_degree_t [N];

    //----------------------------------------------------------
    // Connectivity Tables
    //----------------------------------------------------------

    typedef int cn_conn_t [M][MAX_CN_DEG];

    typedef int vn_conn_t [N][MAX_VN_DEG];

    //----------------------------------------------------------
    // Min-Sum Temporary Storage
    //----------------------------------------------------------

    typedef llr_t magnitude_array_t [MAX_CN_DEG];

    typedef logic sign_array_t [MAX_CN_DEG];

    //----------------------------------------------------------
    // Decoder Status
    //----------------------------------------------------------

    typedef struct packed
    {
        logic               done;
        logic               success;
        iter_t              iter_count;
    }
    decoder_status_t;

endpackage

`default_nettype wire
