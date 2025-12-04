`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2025 10:28:30 PM
// Design Name: 
// Module Name: mat_deinterleave
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


module mat_deinterleave(
    input          i_clk,
	 input          i_clk_e,
    input          i_rst_n,
    // ---------
    input          s_axis_valid,
    output         s_axis_ready,
    // ---------
    output         m_axis_a_valid,
    input          m_axis_a_ready,
    // ---------
    output         m_axis_b_valid,
    input          m_axis_b_ready
    );
reg [1:0] data_count;

reg out_stream;

assign s_axis_ready = out_stream ? m_axis_a_ready : m_axis_b_ready;

assign m_axis_b_valid = out_stream ? 0 : s_axis_valid;
assign m_axis_a_valid = out_stream ? s_axis_valid : 0;


always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n) begin
        data_count <= 0;
		  out_stream <= 0;
    end else
	 if(i_clk_e) begin
    if (s_axis_valid && s_axis_ready && data_count != 2) begin
        data_count <= data_count + 1;
    end
    else if (data_count == 2) begin
        out_stream <= out_stream + 1;
        data_count <= 0;
    end
	 end
end

endmodule