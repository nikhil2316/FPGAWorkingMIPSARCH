`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:48 10/29/2015 
// Design Name: 
// Module Name:    stage3 
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
module stage3(
PCPlus4,
A,
B,
SignExtImme,
Rt,
Rd,
WB,
MEM,
EX,
ForwardA,
ForwardB,
ALUop_inMEM,
MUXop_inWB,
Result,
OutB,
WriteReg,
WBReg,
MEMReg,
Flag
    );
	 
input [31:0] PCPlus4,A,B,SignExtImme;
input [4:0] Rt,Rd;
input [3:0] EX;
input [3:0] MEM;
input [1:0] WB;
input [1:0] ForwardA, ForwardB;
input [31:0] ALUop_inMEM, MUXop_inWB; 

output [31:0] Result,OutB;
//output Equal;
output [4:0] WriteReg;
output [3:0] MEMReg;
output [1:0] WBReg;

parameter Flag_Width = 3;
output [Flag_Width-1:0] Flag;

wire [31:0] ALUOp2;
wire [3:0] ALUCon;

wire [31:0] operandA, operandB;

ALU #(Flag_Width) s0 (.ALUCon(ALUCon),.DataA(operandA),.DataB(ALUOp2),.Result(Result),.Flag(Flag));
Mux32_2_1 s1 (.A(operandB),.B(SignExtImme),.S(EX[3]),.Out(ALUOp2));
//ALU s2 (.ALUCon(4'b0010),.DataA(PCPlus4),.DataB((SignExtImme<<2)),.Result(PCPlus4PlusOff));/////////
ALUControl s3 (.FunC(SignExtImme[5:0]),.ALUOp(EX[1:0]),.ALUCon(ALUCon));

assign operandA = (ForwardA == 2'b00)?(A):((ForwardA == 2'b01)? (MUXop_inWB):(ALUop_inMEM));
assign operandB = (ForwardB == 2'b00)?(B):((ForwardB == 2'b01)? (MUXop_inWB):(ALUop_inMEM));

assign WriteReg = (EX[2])?Rd:Rt;    //0 -> Rt

//assign Equal = (A==B)?(1'b1):(1'b0);
assign OutB = operandB;
assign MEMReg = MEM;
assign WBReg = WB;

endmodule
