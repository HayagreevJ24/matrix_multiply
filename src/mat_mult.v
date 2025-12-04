`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2025 12:30:45 PM
// Design Name: 
// Module Name: mat_mult
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



module mat_mult(
    input              i_clk,
    input              i_rst_n,
    input [7:0]       i_a_num,
    input              i_a_num_valid,
    input [7:0]       i_b_num,
    input              i_b_num_valid,
    output             o_a_read,
    output             o_b_read,
    input              i_res_ready,
    output [7:0]      o_res_data,
    output             o_res_valid,
    output reg         o_res_last
    );

localparam READ_A = 1;
localparam READ_B = 2;
localparam SHIFT_ADD = 3;
localparam OUTPUT = 4;

reg signed [7:0] col_a [0:2];
reg signed [7:0] row_b [0:2];

reg [1:0] a_count;
reg [1:0] b_count;

reg [2:0] current_state;

reg [2:0]  column_adds;
reg        a_full;
reg [1:0]  b_idx_store;

reg [2:0] iterations;


reg [3:0] output_idx;

reg signed [15:0] int_res [0:2];
reg signed [7:0] mat_res [0:8];

assign o_a_read = current_state == READ_A;
assign o_b_read = current_state == READ_B;

assign o_res_valid = current_state == OUTPUT;
assign o_res_data = mat_res[output_idx];

integer i;

initial
begin
    a_count <= 0;
    b_count <= 0;
    column_adds <= 0;
    current_state <= READ_A;
    iterations <= 0;
    output_idx <= 0;
    a_full <= 0;
    o_res_last <= 0;
    for(i = 0; i < 9; i = i+1) begin
      mat_res[i] = 8'h00;
    end
end

always @(posedge i_clk)
begin
    if (!i_rst_n) begin
//        a_count <= 0;
//        b_count <= 0;
//        column_adds <= 0;
//        current_state <= READ_A;
//        iterations <= 0;
//        output_idx <= 0;
//        for(i = 0; i < 9; i = i+1) begin
//            mat_res[i] = 32'h00;
//        end
    end
end

always @(posedge i_clk)
begin
    if ((current_state == READ_B || current_state == SHIFT_ADD) && b_count > 0) begin
        int_res[0] <= col_a[0] * row_b[b_count - 1];
        int_res[1] <= col_a[1] * row_b[b_count - 1];
        int_res[2] <= col_a[2] * row_b[b_count - 1];
        b_idx_store <= b_count - 1;
    end
end

always @(negedge i_clk)
begin
    if ((current_state == READ_B || current_state == SHIFT_ADD) && b_count > 1) begin
        mat_res[0+b_idx_store] <= mat_res[0+b_idx_store] + int_res[0][11:4];
        mat_res[3+b_idx_store] <= mat_res[3+b_idx_store] + int_res[1][11:4];
        mat_res[6+b_idx_store] <= mat_res[6+b_idx_store] + int_res[2][11:4];
    end
end

always @(posedge i_clk)
begin
    case (current_state)
        READ_A: begin
            if (a_count == 3) begin
                current_state <= READ_B;
            end
				else if (i_a_num_valid) begin
                col_a[a_count] <= i_a_num;
                a_count <= a_count + 1;
            end
        end
        READ_B: begin
            if (b_count == 3) begin
                current_state <= SHIFT_ADD;
            end
				else if (i_b_num_valid) begin
                row_b[b_count] <= i_b_num;
                b_count <= b_count + 1;
            end
        end
        SHIFT_ADD: begin
            a_count <= 0;
            b_count <= 0;
            iterations <= iterations + 1;
            if (iterations == 2) begin
                current_state = OUTPUT;
            end else begin
                current_state = READ_A;
            end
        end
        OUTPUT: begin
            if (output_idx == 8) begin
                output_idx <= 0;
                current_state <= READ_A;
                a_count <= 0;
                b_count <= 0;
                o_res_last <= 1;
            end
				else begin
					output_idx <= output_idx + 1;
				end
        end
    endcase
end

endmodule
