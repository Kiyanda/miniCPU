`include "minicpu.h"

module regfile (
	input wire [2:0] srcA,
	input wire [2:0] srcB,
	output reg [`DataBus] valA,
	output reg [`DataBus] valB,
	input wire [2:0] dstM,
	input wire [2:0] dstE,
	input wire [`DataBus] valM,
	input wire [`DataBus] valE,
	input wire clk,
	input wire we_
);
	reg [`DataBus] rf [7:1]; // R0 is zero.
	
	always @(*) begin
		valA = (srcA)? rf[srcA]: 0;
		valB = (srcB)? rf[srcB]: 0;
		end
		
	always @(posedge clk)
		if(we_==`ENABLE_) begin
			if(dstM) rf[dstM] <= valM;
			if(dstE && dstE!=dstM) rf[dstE] <= valE;
			end
endmodule
