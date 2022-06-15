`include "minicpu.h"

module PC (
	input wire [`AddrBus] new_pc,
	output reg [`AddrBus] pc,
	input wire clk,
	input wire rst_
);
	always @ (posedge clk, negedge rst_)
		if (rst_==`ENABLE_) pc <= 0;
		else pc <= new_pc;
endmodule
