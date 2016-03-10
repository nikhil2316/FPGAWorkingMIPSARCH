`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:40:06 10/29/2015 
// Design Name: 
// Module Name:    stage5 
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
module stage5(
MemOp,
ResultRType,
DestReg,
WB,
Result,
RegWrite,
DestRegReg,
reset
    );

input [31:0] MemOp,ResultRType;
input [4:0] DestReg;
input [1:0] WB;
input reset;

output [31:0] Result;
output [4:0] DestRegReg; 
output RegWrite;

Mux32_2_1 s0 (.B(MemOp),.A(ResultRType),.S(WB[0]),.Out(Result));
assign RegWrite = WB[1]&(~reset);
assign DestRegReg = DestReg;

endmodule
