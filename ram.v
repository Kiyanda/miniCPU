`include "minicpu.h"

module ram (
	input wire [`AddrBus] addr,
	output reg [`DataBus] d_out,
	input wire [`DataBus] d_in,
	input wire rd_,
	input wire wr_,
	input wire clk
);
	reg [`DataBus] mem [255:0];
	parameter BYTES = 256;
	
	always @(*)
		if(rd_==`ENABLE_) d_out = mem[addr];
		else d_out = 8'hxx;
		
	always @(posedge clk)
		if(wr_==`ENABLE_) mem[addr] <= d_in;

	integer i;											//
	initial												//
		$readmemh("ram.txt", mem, 0, BYTES-1);			//
	always @(negedge clk) begin							//
		$write("%3d: ", $time);							//
		for(i=0;i<48;i=i+1)								//
			if(mem[i]!==8'hxx) $write(" %c ", mem[i]);	// /*"%x "*/
			else $write(" . ");							//
		$write("\n");									//
		end												//
endmodule
