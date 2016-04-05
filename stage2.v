`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:03 10/29/2015 
// Design Name: 
// Module Name:    stage2 
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
module stage2(
//Inputs
Inst,  //Inst at PC
PCPlus4,		//Nxt Inst Add
WrReg,	//from WB stage
Pipe_stall,		//to stall pipe
FwdA,		//Fwd for Brnch inst
FwdB,
ALUop_inMEM,	//Value in MEM stage
PCPlus4PlusOff,	//Next Brnch addr if it is a Brnch inst
InData,	//
WE,	//Value in WB stage
OutA,		//Content of A in RegBank
OutB,
PCPlus4Reg,
SignExtImme,
Rt,
Rd,
Rs,
WB,		//Control Signals
MEM,
EX,
Equal,
UndefInst,
clk,
RegAddr,
RegData,
IOInst,
Halt
    );

input [31:0] Inst,PCPlus4,InData;
input WE,clk, Pipe_stall;
input [4:0] WrReg;
input [1:0] FwdA, FwdB;
input [31:0] ALUop_inMEM;

output [31:0] OutA, OutB, PCPlus4Reg,SignExtImme,PCPlus4PlusOff;
output [3:0] EX;
output [3:0] MEM;
output [1:0] WB;
output [4:0] Rt,Rd,Rs;
output Equal, UndefInst;
output Halt;

assign Halt=(Inst[31:26]==6'h3F)?(1'b1):(1'b0);

wire [31:0] A, B;
assign PCPlus4Reg = PCPlus4;
assign SignExtImme = {{16{Inst[15]}},Inst[15:0]};
assign Rt = Inst[20:16];
assign Rd = Inst[15:11];
assign Rs = Inst[25:21];

assign A = (FwdA == 2'b00)?(OutA):((FwdA == 2'b01)?(InData):(ALUop_inMEM));
assign B = (FwdB == 2'b00)?(OutB):((FwdB == 2'b01)?(InData):(ALUop_inMEM));

assign Equal = (A==B)?(1'b1):(1'b0);

input [4:0] RegAddr;
output [31:0] RegData;

output IOInst;
assign IOInst = (Inst[31:26]==6'b10_0100 || Inst[31:26]==6'b10_1100)?(1'b1):(1'b0);

Registers s0 (.clock(clk),.WE(WE),.InData(InData),.WrReg(WrReg),.ReadA(Inst[25:21]),.ReadB(Inst[20:16]),.OutA(OutA),.OutB(OutB),.RegAddr(RegAddr),.RegData(RegData));
ControlUnit s1 (.Inst(Inst),.Pipe_stall(Pipe_stall),.Branch({MEM[3],MEM[0]}),.RegWrite(WB[1]),.ALUSrc(EX[3]),.RegDst(EX[2]),.MemW(MEM[1]),.MemR(MEM[2]),.MemToReg(WB[0]),.ALUOp(EX[1:0]),.UndefInst(UndefInst));

parameter Flag_Width = 3;
wire [Flag_Width-1:0] Flag;

ALU #(Flag_Width) s2 (.ALUCon(4'b0010),.DataA(PCPlus4),.DataB((SignExtImme<<2)),.Result(PCPlus4PlusOff),.Flag(Flag));//There might be overflow . We'll take care of it later.
endmodule
