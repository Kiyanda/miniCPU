`ifndef __MINICPU_HEADER__
    `define __MINICPU_HEADER__    
    `define ENABLE_		1'b0
    `define DISABLE_	1'b1
    
    `define DataBus		7:0
    `define AddrBus		7:0
    `define Rom_Bus		23:0
    
	`define NOP			4'h0 //instruction type
    `define LD			4'h1
	`define ST			4'h2 
	`define OPR			4'h3
	`define OPI			4'h4
	`define JMP			4'h5

	`define PUSH		4'h6 //PUSH icode=0x06
	`define POP			4'h7 //POP icode=0x07
	`define CALL		4'h8//CALL icode=0x08
	`define RET			4'h9//RET icode=0x09

	`define HLT			4'hf
	
	`define ADD			4'h0 //fun for alu
	`define SUB			4'h1

	`define PUSHNUMBER	4'h2
	`define POPNUMBER	4'h3

	`define BNG			4'h0 //fun for branch 
	`define BEQ			4'h1
	`define BNE			4'h2
	`define BLT			4'h3
	`define BGT			4'h4
	`define BLE			4'h5
	`define BGE			4'h6

	`define R0			3'o0
	`define RSP			3'o7//规定寄存器7为栈顶寄存器
`endif
