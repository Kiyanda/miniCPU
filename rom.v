`include "minicpu.h"

module rom (
	input  wire [`AddrBus] addr,
	output wire [`Rom_Bus] data
);
	reg [`DataBus] mem [255:0];
	parameter BYTES = 256;

	assign data = {mem[addr], mem[addr+1], mem[addr+2]};

	initial
		$readmemh("rom.txt", mem, 0, BYTES-1);
endmodule




