`timescale 10ps / 1ps


module tb_mat_process();

reg i_clk;
reg i_rst_n;
reg [7:0] i_s_axis_mats;
wire s_axis_ready;
reg i_s_axis_valid;
wire [7:0] m_axis_res;
wire m_axis_valid;
wire m_axis_last;
reg i_m_axis_ready;

integer i;

mat_process dut(
	.axis_clk(i_clk),
	.axis_rst_n(i_rst_n),
	.S_AXIS_MATS(i_s_axis_mats),
	.S_AXIS_READY(s_axis_ready),
	.S_AXIS_VALID(i_s_axis_valid),
	.M_AXIS_RES(m_axis_res),
	.M_AXIS_VALID(m_axis_valid),
	.M_AXIS_LAST(m_axis_last),
	.M_AXIS_READY(i_m_axis_ready)
);


initial
begin
    i_clk <= 0;
    i_rst_n <= 0;
    i <= 0;
	 
    i_s_axis_valid <= 0;
    i_m_axis_ready <= 1;
	 i_s_axis_mats <= 8'h10;
	 
    #20
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