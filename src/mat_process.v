`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 07:38:19 PM
// Design Name: 
// Module Name: mat_process
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mat_process(
    input axis_clk,
    input axis_rst_n,
    input [7:0] S_AXIS_MATS,
    output S_AXIS_READY,
    input S_AXIS_VALID,
    output [7:0] M_AXIS_RES,
    output M_AXIS_VALID,
    output M_AXIS_LAST,
    input M_AXIS_READY,
	 input DATA_SEL,
	 output clk_out
    );
    
wire axis_a_ready, axis_a_valid, axis_b_ready, axis_b_valid;

wire [7:0] partial_mult_data;
wire partial_mult_ready, partial_mult_valid, partial_mult_last;

//assign clk_out = axis_clk;

//SignalTap u0 (
//	.acq_data_in    ({M_ASXIS_RES, M_AXIS_VALID}),    //     tap.acq_data_in
//	.acq_trigger_in (M_AXIS_VALID), //        .acq_trigger_in
//	.acq_clk        (axis_clk)         // acq_clk.clk
//);


wire [7:0] S_AXIS_DATA = DATA_SEL ? S_AXIS_MATS : 8'h18;

wire axis_clk_e;

//pll clk_pll(
//	.areset(axis_rst_n),
//	.inclk0(axis_clk),
//	.c0(clock),
//	.locked(locked)
//);

clock_enable clk_gate(
	.clk(axis_clk),
	.rst_n(axis_rst_n),
	.clk_en(axis_clk_e),
	.clk_out(clk_out)
);

mat_deinterleave deinter (
    .i_clk(axis_clk),
	 .i_clk_e(axis_clk_e),
    .i_rst_n(axis_rst_n),
    // ---------
    .s_axis_valid(S_AXIS_VALID),
    .s_axis_ready(S_AXIS_READY),
    // ---------
    .m_axis_a_valid(axis_a_valid),
    .m_axis_a_ready(axis_a_ready),
    // ---------
    .m_axis_b_valid(axis_b_valid),
    .m_axis_b_ready(axis_b_ready)
);

mat_partial_mult multiplier(
    .i_clk(axis_clk),
	 .i_clk_e(axis_clk_e),
    .i_rst_n(axis_rst_n),
    .i_a_num(S_AXIS_DATA),
    .i_a_num_valid(axis_a_valid),
    .i_b_num(S_AXIS_DATA),
    .i_b_num_valid(axis_b_valid),
    .o_a_read(axis_a_ready),
    .o_b_read(axis_b_ready),
    .i_res_ready(partial_mult_ready),
    .o_res_data(partial_mult_data),
    .o_res_valid(partial_mult_valid),
    .o_res_last(partial_mult_last)
);

mat_accum accumulator(
	.i_clk(axis_clk),
	.i_clk_e(axis_clk_e),
	.i_rst_n(axis_rst_n),
	// ---------
	.s_axis_data(partial_mult_data),
	.s_axis_ready(partial_mult_ready),
	.s_axis_valid(partial_mult_valid),
	.s_axis_last(partial_mult_last),
	// ---------
	.m_axis_res_data(M_AXIS_RES),
	.m_axis_res_ready(M_AXIS_READY),
	.m_axis_res_valid(M_AXIS_VALID),
	.m_axis_res_last(M_AXIS_LAST)
);
endmodule