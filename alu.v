`include "minicpu.h"

module ALU (
    input wire [`DataBus] A,
    input wire [`DataBus] B,  // E = A op B
    output reg [`DataBus] E,
	input wire [3:0] op,
    output reg [1:0] cc  // Cond. code: set when E = A - B
);						 //    (A==B)? 1x: ((A>B)? 01: 00)
	always @(*) begin
		E = 8'hxx;
		cc = 2'bxx;
		case (op)
			4'h0 : E = A + B;
			4'h1 : begin
				E = A - B;
				cc = {!E, $signed(E)>0};
				end
			endcase
		end
endmodule
