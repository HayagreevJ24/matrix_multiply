`timescale 1ns/1ps

module clock_enable(
    input clk,
	 input rst_n,
    output reg clk_en,
    output clk_out // This is only used for external clock information and is not on the clock tree
);
reg [15:0] counter;
assign clk_out = counter[15];

always @(posedge clk, negedge rst_n)
begin
	if (!rst_n) begin
		counter <= 16'b0;
		clk_en <= 1'b0;
	end else begin
		if (counter == 16'hFFFF) begin
			clk_en <= 1'b1;
			counter <= 16'b0;
		end else	begin
			clk_en <= 1'b0;
			counter <= counter + 16'b1;
		end
	end
end


endmodule