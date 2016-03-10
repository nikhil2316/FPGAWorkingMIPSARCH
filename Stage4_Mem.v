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
module Stage4(
PCPlus4PlusOff,
ALUResult,
B,
WrReg,
WB,
MEM,
WriteReg,
MemOp,
ResultRType,
WBReg
    );

input [31:0] PCPlus4PlusOff,ALUResult,B;
input [4:0] WrReg;
input [3:0] MEM;
input [1:0] WB;

output[31:0] MemOp,ResultRType;
output [4:0] WriteReg;
output [1:0] WBReg;


assign WriteReg = WrReg;

assign ResultRType = ALUResult;
assign WBReg = WB;

DATAMEM s0 (.MemWrite(MEM[1]),.MemRead(MEM[2]),.Addr(ALUResult),.Wdata(B),.Rdata(MemOp));
//NextAddGen s1 (.Branch({MEM[3],MEM[0]}),.Equal(Equal),.PCSrc(PCSrc));
endmodule
