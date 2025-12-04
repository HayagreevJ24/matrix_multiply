`timescale 10ps / 1ps


module tb_mat_deinterleave();

reg i_clk;
reg i_rst_n;
wire s_axis_ready;
reg i_s_axis_valid;
wire m_axis_a_valid, m_axis_b_valid;
reg i_m_axis_a_ready, i_m_axis_b_ready;

integer i;

mat_deinterleave dut(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    // ---------
    .s_axis_valid(i_s_axis_valid),
    .s_axis_ready(s_axis_ready),
    // ---------
    .m_axis_a_valid(m_axis_a_valid),
    .m_axis_a_ready(i_m_axis_a_ready),
    // ---------
    .m_axis_b_valid(m_axis_b_valid),
    .m_axis_b_ready(i_m_axis_b_ready)
);


initial
begin
	i_clk <= 0;
	i_rst_n <= 0;
	i <= 0;

	i_s_axis_valid <= 0;

	i_m_axis_b_ready <= 0;
	i_m_axis_a_ready <= 0;

	#10
	i_rst_n <= 1;

	i_m_axis_b_ready <= 1;
	i_m_axis_a_ready <= 0;

	@(posedge i_clk);
	for (i = 0; i < 3; i = i + 1) begin
		i_s_axis_valid <= 1;
		@(posedge i_clk);
		@(posedge i_clk);
		@(posedge i_clk);
		i_m_axis_b_ready <= 0;
		i_m_axis_a_ready <= 1;
		@(posedge i_clk);
		i_m_axis_a_ready <= 0;
		@(posedge i_clk);
		i_m_axis_a_ready <= 1;
		@(posedge i_clk);
		i_m_axis_a_ready <= 0;
		@(posedge i_clk);
		i_m_axis_a_ready <= 1;
		@(posedge i_clk);
		i_s_axis_valid <= 0;
	end
end


always
begin
	#10 i_clk <= ~i_clk;
end


endmodule