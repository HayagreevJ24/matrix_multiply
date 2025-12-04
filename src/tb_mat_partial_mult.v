`timescale 10ps / 1ps


module tb_mat_partial_mult();

reg i_clk;
reg i_rst_n;
reg [7:0] i_a_num;
reg i_a_num_valid;
reg [7:0] i_b_num;
reg i_b_num_valid;

wire a_ready, b_ready;

reg i_res_ready;

wire [7:0] res_data;
wire res_valid;
wire res_last;


integer i;

mat_partial_mult dut(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_a_num(i_a_num),
	.i_a_num_valid(i_a_num_valid),
	.i_b_num(i_b_num),
	.i_b_num_valid(i_b_num_valid),
	.o_a_read(a_ready),
	.o_b_read(b_ready),
	.i_res_ready(i_res_ready),
	.o_res_data(res_data),
	.o_res_valid(res_valid),
	.o_res_last(res_last)
);


initial
begin
	i_clk <= 0;
	i_rst_n <= 0;
	i <= 0;
	i_a_num_valid <= 1;
	i_b_num_valid <= 1;
	
	i_res_ready <= 1;
	
	i_a_num <= 8'h10;
	i_b_num <= 8'h10;

	#10
	i_rst_n <= 1;
end

always @(posedge i_clk)
begin
	if (a_ready) begin
		if (i_a_num == 8'h30) begin
			i_a_num <= 8'h10;
		end else begin
			i_a_num <= i_a_num + 8'h10;
		end
	end
	if (b_ready) begin
		if (i_b_num == 8'h30) begin
			i_b_num <= 8'h10;
		end else begin
			i_b_num <= i_b_num + 8'h10;
		end
	end
end


always
begin
	#10 i_clk <= ~i_clk;
end


endmodule