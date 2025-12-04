`timescale 10ps / 1ps


module tb_mat_accum();

reg i_clk;
reg i_rst_n;
reg [7:0] i_s_axis_mats;
wire s_axis_ready;
reg i_s_axis_valid;
wire [7:0] m_axis_res;
wire m_axis_valid;
wire m_axis_last;
reg i_m_axis_ready;

reg floating;

integer i;

mat_accum dut(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	// ---------
	.s_axis_data(i_s_axis_mats),
	.s_axis_ready(s_axis_ready),
	.s_axis_valid(i_s_axis_valid),
	.s_axis_last(floating),
	// ---------
	.m_axis_res_data(m_axis_res),
	.m_axis_res_ready(i_m_axis_ready),
	.m_axis_res_valid(m_axis_valid),
	.m_axis_res_last(m_axis_last)
);


initial
begin
    i_clk <= 0;
    i_rst_n <= 0;
    i <= 0;
	 
    i_s_axis_valid <= 0;
    i_m_axis_ready <= 1;
	 i_s_axis_mats <= 8'h10;
	 
    #10
    i_rst_n <= 1;
	 i_s_axis_valid <= 1;
	 
end

always @(posedge i_clk)
begin
	if (s_axis_ready && i_s_axis_valid) begin
		if (i_s_axis_mats == 8'h30) begin
			i_s_axis_mats <= 8'h10;
		end else begin
			i_s_axis_mats <= i_s_axis_mats + 8'h10;
		end
	end
end


always
begin
	#10 i_clk <= ~i_clk;
end


endmodule