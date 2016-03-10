`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:38 10/29/2015 
// Design Name: 
// Module Name:    MemWB 
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
module MemWB(
MemOp,
ResultRType,
WrReg,
WB,
MemOpReg,
ResultRTypeReg,
WrRegReg,
WBReg,
clk,
reset
    );

input [31:0] MemOp,ResultRType;
input [4:0] WrReg;
input [1:0] WB;
input clk, reset;

output [31:0] MemOpReg,ResultRTypeReg;
output [4:0] WrRegReg;
output [1:0] WBReg;

reg [31:0] MemOpReg,ResultRTypeReg;
reg [4:0] WrRegReg;
reg [1:0] WBReg;
//assign WBReg = WB;

always @ (posedge clk)
begin
	if(reset)
	begin
		MemOpReg <= 0;
		ResultRTypeReg <= 0;
		WrRegReg <= 0;
		WBReg <= 0;
	end
	else
	begin
		MemOpReg <= MemOp;
		ResultRTypeReg <= ResultRType;
		WrRegReg <= WrReg;
		WBReg <= WB;
	end
end




endmodule
