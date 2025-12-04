`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2025 10:28:30 PM
// Design Name: 
// Module Name: mat_accum
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


module mat_accum(
	input               i_clk,
	input               i_clk_e,
	input               i_rst_n,
	// ---------
	input signed [7:0]  s_axis_data,
	output              s_axis_ready,
	input               s_axis_valid,
	input               s_axis_last,
	// ---------
	output signed [7:0] m_axis_res_data,
	input               m_axis_res_ready,
	output              m_axis_res_valid,
	output reg          m_axis_res_last
);

localparam READING = 0;
localparam OUTPUTTING = 1;

reg [0:0] current_state;

reg signed [7:0] matrix [8:0];

reg [2:0] iteration;
reg [3:0] idx;


assign m_axis_res_data = matrix[idx];
assign m_axis_res_valid = current_state == OUTPUTTING;

assign s_axis_ready = current_state == READING;

always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n) begin
		iteration <= 0;
		idx <= 0;
		current_state <= READING;
	end else
   if(i_clk_e) begin
		case (current_state)
			READING: begin
				if (s_axis_valid) begin
					if (idx == 8) begin
						idx <= 0;
						iteration <= iteration + 1;
						if (iteration == 2) begin
							current_state <= OUTPUTTING;
						end
					end
					else begin
						idx <= idx + 1;
					end
				
				
					if (iteration == 0) begin
						matrix[idx] <= s_axis_data;
					end else begin
						matrix[idx] <= matrix[idx] + s_axis_data;
					end
					
				end
			end
			
			OUTPUTTING: begin
				if (idx == 8) begin
					idx <= 0;
					iteration <= 0;
					current_state <= READING;
				end
				else begin
					idx <= idx + 1;
				end
			end
		endcase
	end
end

endmodule