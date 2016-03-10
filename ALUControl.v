`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:26 10/30/2015 
// Design Name: 
// Module Name:    ALUControl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALUControl(
FunC,
ALUOp,
ALUCon
    );
	 
input [5:0] FunC;
input [1:0] ALUOp;

output [3:0] ALUCon;
reg [3:0] ALUCon;

always @ (FunC,ALUOp)
begin
	casex({ALUOp,FunC})
		8'b00_100000:
						 ALUCon <= 4'b0010;
		8'b00_100100:
						 ALUCon <= 4'b0000;
		8'b00_100111:
						 ALUCon <= 4'b0100;
		8'b00_100101:
						 ALUCon <= 4'b0001;
		8'b00_101010:
						 ALUCon <= 4'b0111;
		8'b00_100010:
						 ALUCon <= 4'b0110;
		8'b00_011010:
						 ALUCon <= 4'b0101;
		8'b00_011000:
						 ALUCon <= 4'b0011;

		8'b01_xxxxxx:
						 ALUCon <= 4'b0010;
						 
		8'b10_xxxxxx:
						 ALUCon <= 4'b0001;		
	endcase
end	 


endmodule
