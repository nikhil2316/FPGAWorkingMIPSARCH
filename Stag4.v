`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:12 10/29/2015 
// Design Name: 
// Module Name:    stage4 
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
module stage4(
PCPlus4PlusOff,
Equal,
ALUResult,
B,
WrReg,
WriteReg,
PCPlus4PlusOffset,
MemOp,
ResultRType,
clk
    );

input [31:0] PCPlus4PlusOff,ALUResult,B;
input [4:0] WrReg;
input Equal,clk;

output[31:0] PCPlus4PlusOffset,MemOp,ResultRType;
output [4:0] WriteReg;

assign WriteReg = WrReg;
assign PCPlus4PlusOffset = PCPlus4PlusOff;
assign ResultRType = ALUResult;

DATAMEM s0 (.MemWrite(),.MemRead(),.Addr(ALUResult),.Wdata(B),.Rdata(MemOp));

endmodule
