`include "minicpu.h"

`define ins	 rom_data[23:20]
`define fun	 rom_data[19:16]
`define rA	 rom_data[14:12]
`define rB	 rom_data[10: 8]
`define rC	 rom_data[ 6: 4]
`define valC rom_data[ 7: 0]

module minicpu (
	output wire [`AddrBus] ram_addr,
	output wire [`DataBus] ram_d_in,
	input  wire [`DataBus] ram_d_out,
	output reg ram_rd_, ram_wr_,

	output wire [`AddrBus] rom_addr,
	input  wire [`Rom_Bus] rom_data,

	input  wire clk,
	input  wire rst_
);
	reg  [`AddrBus] valP;
	wire [`DataBus] valA, valB, valE;
	reg  [2:0] dstM, dstE;
	reg  [`DataBus] aluB;
	reg  [3:0] op;
	wire [1:0] cc;
	reg  [`AddrBus] new_pc;
	
	PC PC (
	.new_pc (new_pc),
	.pc     (rom_addr),
	.clk    (clk),
	.rst_   (rst_)
	);
	
	always @(*) begin
		valP = rom_addr + ((`ins==`HLT)? 0: (`ins==`NOP)? 1: 3);
		dstM = (`ins==`LD )? `rB: `R0;
		dstE = (`ins==`OPR)? `rC: (`ins==`OPI)? `rB: `R0;
		end

	regfile regfile (
	.srcA (`rA),
	.srcB (`rB),
	.valA (valA),
	.valB (valB),
	.dstM (dstM),
	.dstE (dstE),	
	.valM (ram_d_out),
	.valE (valE),
	.clk  (clk),
	.we_  (~rst_)
	);
	
	always @(*) begin
		aluB = (`ins==`LD||`ins==`ST||`ins==`OPI||{`ins, `fun}=={`JMP, `BNG})? `valC: valB;
		op = (`ins==`OPR||`ins==`OPI)? `fun : (`ins==`JMP&&`fun!=`BNG)? `SUB: `ADD;
		end

	ALU ALU (
    .A  (valA),
    .B  (aluB),
    .E  (valE),
	.op (op),
    .cc (cc)	// set when E = A - B, (A==B)? 1x: (A>B)? 01: 00.
	);

	assign ram_addr = valE;
	assign ram_d_in = valB;
	always @(*) begin
		ram_rd_ = (`ins==`LD)? `ENABLE_: `DISABLE_;
		ram_wr_ = (rst_&&`ins==`ST)? `ENABLE_: `DISABLE_;
		end
		
	always @(*) begin
		new_pc = valP;
		case ({`ins, `fun})
			{`JMP, `BNG} : new_pc = valE;
			{`JMP, `BEQ} : if( cc[1:1]) new_pc = `valC;
			{`JMP, `BNE} : if(~cc[1:1]) new_pc = `valC;
			{`JMP, `BLT} : if(~cc[1:1]&~cc[0:0]) new_pc = `valC;
			{`JMP, `BGT} : if(~cc[1:1]& cc[0:0]) new_pc = `valC;
			{`JMP, `BLE} : if( cc[1:1]|~cc[0:0]) new_pc = `valC;
			{`JMP, `BGE} : if( cc[1:1]| cc[0:0]) new_pc = `valC;
			endcase
		end
endmodule
