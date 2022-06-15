`timescale 10ns/1ns

`include "minicpu.h"

module test;
	wire [`AddrBus] ram_addr;
	wire [`DataBus] ram_d_in;
	wire [`DataBus] ram_d_out;
	wire ram_rd_, ram_wr_;
	wire [`AddrBus] rom_addr;
	wire [`Rom_Bus] rom_data;
	reg clk, rst_;
	integer i;
	
	parameter CYCLE = 1.0;
	
	ram ram (
	.addr	(ram_addr),
	.d_out	(ram_d_out),
	.d_in	(ram_d_in),
	.rd_	(ram_rd_),
	.wr_	(ram_wr_),
	.clk	(clk)
	);

	rom rom (
	.addr	(rom_addr),
	.data	(rom_data)
	);
	
	minicpu minicpu (
	.ram_addr	(ram_addr),
	.ram_d_in	(ram_d_in),
	.ram_d_out	(ram_d_out),
	.ram_rd_	(ram_rd_),
	.ram_wr_	(ram_wr_),
	.rom_addr	(rom_addr),
	.rom_data	(rom_data),
	.clk		(clk),
	.rst_		(rst_)
	);

	always #(CYCLE/2) clk <= ~clk;
	
	initial begin
		clk = 1'b1;
		rst_ = `ENABLE_;

	#(CYCLE+CYCLE/2)
		rst_ = `DISABLE_;
		end
		
	always @(negedge clk)
		if(rst_&&rom_data[23:20]==4'hf) #(CYCLE+0.1) $finish;
	
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0, rom);
		$dumpvars(0, ram);
		$dumpvars(0, minicpu);
		end
endmodule
