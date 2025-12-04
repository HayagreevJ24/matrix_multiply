`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2025 12:30:45 PM
// Design Name: 
// Module Name: mat_partial_mult
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



module mat_partial_mult(
	input              i_clk,
	input              i_clk_e,
	input              i_rst_n,
	input signed [7:0]       i_a_num,
	input              i_a_num_valid,
	input signed [7:0]       i_b_num,
	input              i_b_num_valid,
	output             o_a_read,
	output             o_b_read,
	input              i_res_ready,
	output reg signed [7:0]      o_res_data,
	output reg         o_res_valid,
	output reg         o_res_last
);

localparam READ_A = 0;
localparam READ_B = 1;
localparam MULTIPLY = 2;
localparam OUTPUT_MULTIPLY = 3;

reg signed [7:0] col_a [0:2];
reg signed [7:0] row_b [0:2];

reg [15:0] tmp;

reg [1:0] a_count;
reg [1:0] b_count;

reg [2:0] current_state;

reg [1:0]  b_idx_store;

reg [2:0] iterations;

reg [2:0] mult_iterations;

assign o_a_read = current_state == READ_A;
assign o_b_read = current_state == READ_B;


always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n) begin
		 a_count <= 0;
		 b_count <= 0;
		 current_state <= READ_B;
		 iterations <= 0;
		 o_res_last <= 0;
		 mult_iterations <= 0;
		 o_res_valid <= 0;
	end else
   if(i_clk_e) begin
		case (current_state)
			READ_B: begin
				o_res_valid <= 0;
				o_res_last <= 0;
				if (i_b_num_valid) begin
					row_b[b_count] <= i_b_num;
					if (b_count == 2) begin
						current_state <= READ_A;
						b_count <= 0;
					end else begin
						b_count <= b_count + 1;
					end
				end
			end
			READ_A: begin
				if (i_a_num_valid) begin
					col_a[a_count] <= i_a_num;
					if (a_count == 2) begin
						current_state <= OUTPUT_MULTIPLY;
						iterations <= iterations + 1;
						a_count <= 0;
					end else begin
						a_count <= a_count + 1;
					end
				end
			end

			OUTPUT_MULTIPLY: begin
				o_res_valid <= 1;
				
				tmp = col_a[mult_iterations] * row_b[a_count];
				o_res_data <= tmp[11:4];
				
				if (a_count == 2) begin
					a_count <= 0;
					
					if (mult_iterations == 2) begin
						mult_iterations <= 0;
						current_state <= READ_B;
						if (iterations == 2) begin
							iterations <= 0;
							o_res_last <= 1;
						end else begin
							iterations <= iterations + 1;
						end
					end
					else begin
						mult_iterations <= mult_iterations + 1;
					end
					
					
					
				end
				else begin
					a_count <= a_count + 1;
				end
			end
		endcase
	end
end

endmodule