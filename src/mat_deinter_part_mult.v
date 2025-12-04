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


module mat_deinter_part_mult(
    input axis_clk,
    input axis_rst_n,
    input [7:0] S_AXIS_MATS,
    output S_AXIS_READY,
    input S_AXIS_VALID,
    output [7:0] M_AXIS_RES,
    output M_AXIS_VALID,
    output M_AXIS_LAST,
    input M_AXIS_READY,
	 output clk_out
    );
    
wire axis_a_ready, axis_a_valid, axis_b_ready, axis_b_valid;

wire clk_enable;

clock_enable clk_enabler(
    .clk(axis_clk),
    .clk_en(clk_enable),
    .clk_out(clk_out)
);

mat_deinterleave deinter (
    .i_clk(axis_clk),
	.i_clk_e(clk_enable),
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
	 .i_clk_e(clk_enable),
    .i_rst_n(axis_rst_n),
    .i_a_num(S_AXIS_MATS),
    .i_a_num_valid(axis_a_valid),
    .i_b_num(S_AXIS_MATS),
    .i_b_num_valid(axis_b_valid),
    .o_a_read(axis_a_ready),
    .o_b_read(axis_b_ready),
    .i_res_ready(M_AXIS_READY),
    .o_res_data(M_AXIS_RES),
    .o_res_valid(M_AXIS_VALID),
    .o_res_last(M_AXIS_LAST)
);
endmodule
