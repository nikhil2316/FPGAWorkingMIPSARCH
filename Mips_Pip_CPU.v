`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:14:01 10/30/2015 
// Design Name: 
// Module Name:    Mips_Pip_CPU 
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
module Mips_Pip_CPU_Orig(
clock,
RegisterContent,
RegisterNo,
PC,
Instruction,
//DataMem
DataAddr,
DataIn,
DataOut,
//MEMReg_s5,
DataMemWrite,
//////
reset,
ipbar_op,
Port,
//Register Ports
RegAddr,
RegData,

//InterruptHandling
NMI,
NMI_ACK,
NMI_ID,
RSM
 );
 
input clock, reset;
input [31:0] Instruction, DataIn;

output [31:0] RegisterContent;
output [4:0] RegisterNo;
output [31:0] PC, DataAddr,DataOut;
output ipbar_op; //We'll take care of it later

inout [31:0] Port;

input RSM;//Resume Pin, it has to be high for atlest 2 clk periods
//Interrupt Handling
input NMI;
output NMI_ACK;
reg NMI_ACK;
input [1:0] NMI_ID;

wire clk;

//for exception handling
parameter MEM_SIZE = 32'd512;// Inst Mem size
//parameter ExceptionAddr = 32'd512;//set THIS FOR EXCEPTION HANDLING, Actually there should be 2 addrs, one for undef inst exception and other for overflow exception
wire [31:0] ExceptionAddr;
//wire [31:0] EPC; //to save PC of offending inst. Exception Program Counter
wire Cause;//0->undefined inst. 1->overflow or underflow 
//output [31:0] Address_Bus;
wire EX_Mem_Flush, ID_EX_Flush, IF_ID_Flush;//for exception handling
wire ChooseEPC;

wire [1:0] PCSrc;//msb for indicating jmp addr and lsb for branch addr
wire [31:0] PCPlus4PlusOffset;
wire [31:0] PCPlus4,Inst;
wand PCWrite, IF_ID_Write ;//////
//wire  EX_Flush;
wire [31:0] JmpAddr;
wor Pipe_stall;

wire [31:0] PC_stage2;///
wire  FindinBTB, taken;
wire [2:0] WriteEntry;

Stage1 s0 (.PCSrc(PCSrc),.PCPlus4PlusOff(PCPlus4PlusOffset),.PCWrite(PCWrite),.JmpAddr(JmpAddr),.ExceptionResumeAddr(ExceptionAddr),.ChooseEPC(ChooseEPC),.PC_stage2(PC_stage2),.WriteEntry(WriteEntry),.PCPlus4(PCPlus4), .FindinBTB(FindinBTB), .taken(taken),.clk(clk),.PC_out(PC),.reset(reset));
//Stage1 s0 (PCSrc,PCPlus4PlusOffset,PCPlus4,Inst,clk);

wire [31:0] PCPlus4Reg,InstReg;
wire FindinBTBReg, takenReg;
IFID s1 (.PCPlus4(PCPlus4),.Inst(Instruction),.IF_ID_Write(IF_ID_Write),.IF_ID_Flush_excep(IF_ID_Flush),.PCSrc({WriteEntry[2],PCSrc[1:0]}),.FindinBTB(FindinBTB), .taken(taken),.PCPlus4Reg(PCPlus4Reg),.InstReg(InstReg),.FindinBTBReg(FindinBTBReg), .takenReg(takenReg),.clk(clk),.reset(reset));

wire [4:0] WrReg;
wire [31:0] InData;
wire RegWrite, UndefInst;
wire [31:0] OutA,OutB, ResultReg;
wire [31:0] PCPlus4Reg_s2,SignExtImme,PCPlus4PlusOff;
wire [4:0] Rt,Rd,Rs;
wire [1:0] WB;
wire [3:0] MEM;
wire [3:0] EX;
wire Equal;
wire [1:0] FwdA, FwdB;

input [4:0] RegAddr;
output [31:0] RegData;
wire IOInst,Halt;
stage2 s2 (.Inst(InstReg),.PCPlus4(PCPlus4Reg),.WrReg(WrReg),.Pipe_stall(Pipe_stall),.InData(InData),.FwdA(FwdA),.FwdB(FwdB),.ALUop_inMEM(ResultReg)/*,.MUXop_inWB(InData)*/,.PCPlus4PlusOff(PCPlus4PlusOffset),.WE(RegWrite),.OutA(OutA),.OutB(OutB),.PCPlus4Reg(/*PCPlus4Reg_s2*/),.SignExtImme(SignExtImme),.Rt(Rt),.Rd(Rd), .Rs(Rs),.WB(WB),.MEM(MEM),.EX(EX),.Equal(Equal),.UndefInst(UndefInst),.clk(clk),.RegData(RegData),.RegAddr(RegAddr),.IOInst(IOInst),.Halt(Halt));


//////////////////////////\\\\\\Control Resolving Unit\\\\///////////////////////////////////////
NextAddGen NAG (.Branch({MEM[3],MEM[0]}),.Equal(Equal),.PCSrc(PCSrc[0]), .FindinBTB(FindinBTBReg), .taken(takenReg), .WriteEntry(WriteEntry),.Pipe_stall(Pipe_stall),.reset(reset));

assign PC_stage2 = PCPlus4Reg - 32'd4;
//////////////////////////-----------------------//////////////////////////////

/////////////////////////Jmp Inst///////////////////////////////////////////////
wire [31:0] ResumeAddr;
jmp_instr j (.Inst(InstReg), .PCPlus4(PCPlus4Reg), .PCSrc(PCSrc[1]), .JmpAddr(JmpAddr),.ResumeAddr(ResumeAddr),.reset(reset));
///////////////////////////////////////////////////////////////////////////////////////
wire [31:0] PCPlus4Reg_s3,AReg,BReg,SignExtImmeReg;
wire [4:0] RtReg,RdReg,RsReg;
wire [1:0] WBReg;
wire [3:0] MEMReg;
wire [3:0] EXReg;
wire IOInstReg_s3;

reg [31:0] PCPlus4RegLatched;
always @ (negedge clk)
begin
	PCPlus4RegLatched <= PCPlus4Reg;
end

wire HaltReg_s3;
IDEX s3 (.PCPlus4(PCPlus4RegLatched),.A(OutA),.B(OutB),.SignExtImme(SignExtImme),.Rt(Rt),.Rd(Rd), .Rs(Rs),.WB(WB),.MEM(MEM),.EX(EX),.ID_EX_Flush_excep(ID_EX_Flush),.PCPlus4Reg(PCPlus4Reg_s3),.AReg(AReg),.BReg(BReg),.SignExtImmeReg(SignExtImmeReg),.RtReg(RtReg),.RdReg(RdReg),.RsReg(RsReg),.WBReg(WBReg),.MEMReg(MEMReg),.EXReg(EXReg),.clk(clk),.reset(reset),.IOInst(IOInst),.IOInstReg(IOInstReg_s3),.Halt(Halt),.HaltReg(HaltReg_s3));

///////////Interrupt Synchronization//////////////////
reg NMIReg; //sync NMI
reg [1:0] NMI_IDReg;
reg Interrupt=0;
always @ (posedge reset, posedge clk)
begin
	if(reset)
	begin
		NMIReg <= 0;
		NMI_IDReg <= 2'd0;
	end
	else
	begin
		NMIReg <= NMI;
		NMI_IDReg <= NMI_ID;
	end
end

reg AsyncR;
always @ (posedge AsyncR,posedge NMIReg)
begin
	if(AsyncR)
		Interrupt <= 0;
	else
		Interrupt <= ~Interrupt;
end
always @ (posedge reset, posedge clk)
begin
	if(reset)
	begin
		AsyncR <= 1;
	end
	else
	begin
		AsyncR <= Interrupt;
	end
end

////////////////////////////////////////////////////////
///////////Interrupt Acknowledge/////////////////////////
wire NMI_ACKRst, jumpfromISR;
reg jumpfromISRReg1,jumpfromISRReg2;
assign jumpfromISR = (InstReg[31:26] == 6'h3)?(1'b1):(1'b0);
always @ (posedge clk, posedge reset)
begin
	if(reset)
	begin
		jumpfromISRReg1 <= 0;
		jumpfromISRReg2 <= 0;
	end
	else
	begin
		jumpfromISRReg1 <= jumpfromISR;
		jumpfromISRReg2 <= jumpfromISRReg1;
	end
end

assign NMI_ACKRst = (reset | jumpfromISRReg2 & (~NMI_ACK)  )?(1'b1):(1'b0);

always @ (posedge NMI_ACKRst,posedge NMIReg)
begin
	if(NMI_ACKRst)
	begin
		NMI_ACK <= 1'b1;
	end
	else
	begin
		NMI_ACK <= 1'b0;
	end
end
/////////////////////////////////////////////////////////

wire [31:0] /*PCPlus4PlusOff,*/Result,B/*, ResultReg*/;
//wire Equal;
wire [4:0] WriteReg;
wire [3:0] MEMReg_s4;
wire [1:0] WBReg_s4;
wire [1:0] ForwardA, ForwardB;

parameter Flag_Width = 3;
wire [Flag_Width-1:0] Flag;
stage3 #(Flag_Width) s4 (.PCPlus4(PCPlus4Reg_s3),.A(AReg),.B(BReg),.SignExtImme(SignExtImmeReg),.Rt(RtReg),.Rd(RdReg),.WB(WBReg),.MEM(MEMReg),.EX(EXReg),.ForwardA(ForwardA),.ForwardB(ForwardB),.ALUop_inMEM(ResultReg),.MUXop_inWB(InData),.Result(Result),.OutB(B),.WriteReg(WriteReg),.WBReg(WBReg_s4),.MEMReg(MEMReg_s4),.Flag(Flag));

///////////////////////////////////Exception/Interrupt Control Block///////////////////////////////////

ExceptionBlock #(Flag_Width) EXP (.Flag_EX(Flag),
.Flag_ID(UndefInst),
.PCInterruptedinID(PCPlus4Reg), //corresponding to UndefInst
.PCInterruptedinEX(PCPlus4Reg_s3), //corresponding to Overflow
.EPC(ResumeAddr),
.Cause(Cause),
.EX_Mem_Flush(EX_Mem_Flush),
.ID_EX_Flush(ID_EX_Flush),
.IF_ID_Flush(IF_ID_Flush),
.ChooseEPC(ChooseEPC),
.clk(clk),
.reset(reset),
.Excep_IntAddr(ExceptionAddr),
.NMI(Interrupt),
.NMI_ID(NMI_IDReg)
);

//////////////////////////////------------------------//////////////////////////////////////////////

wire [31:0] PCPlus4PlusOffReg/*,ResultReg*/,B_Reg;
wire EqualReg;
wire [4:0] WrRegReg;
//output [3:0] MEMReg_s5;
wire [3:0] MEMReg_s5;
wire [1:0] WBReg_s5;
wire IOInstReg_s5,HaltReg_s5;
EXMem s5 (.PCPlus4PlusOff(PCPlus4PlusOff),.Equal(Equal),.Result(Result),.OutB(B),.WrReg(WriteReg),.WB(WBReg_s4),.MEM(MEMReg_s4),.EX_Mem_Flush_excep(EX_Mem_Flush),.PCPlus4PlusOffReg(PCPlus4PlusOffReg),.EqualReg(EqualReg),.ResultReg(ResultReg),.OutBReg(B_Reg),.WrRegReg(WrRegReg),.WBReg(WBReg_s5),.MEMReg(MEMReg_s5),.clk(clk),.reset(reset),.IOInst(IOInstReg_s3),.IOInstReg(IOInstReg_s5),.Halt(HaltReg_s3),.HaltReg(HaltReg_s5));

wire[31:0] MemOp,ResultRType;
wire [4:0] DestReg;
wire [1:0] WBReg_s6;

assign DataAddr = ResultReg;
assign DataOut = B_Reg;
assign MemOp = (IOInstReg_s5)?(Port):(DataIn);	//either from port if IOInst=1 or from memory
assign ipbar_op = (IOInstReg_s5 & MEMReg_s5[1])?(1'b1):(1'b0);

output DataMemWrite;
assign DataMemWrite = MEMReg_s5[1]&(~IOInstReg_s5);
assign Port=(IOInstReg_s5 & MEMReg_s5[1])?(B_Reg):(32'bz);

Stage4 s6 (.PCPlus4PlusOff(PCPlus4PlusOffReg),
.ALUResult(ResultReg),
.B(B_Reg),
.WrReg(WrRegReg),
.WB(WBReg_s5),
.MEM(MEMReg_s5),
.WriteReg(DestReg),
.MemOp(/*MemOp*/),
.ResultRType(ResultRType),
.WBReg(WBReg_s6)
//,.clk(clk)
);

wire [31:0] MemOpReg,ResultRTypeReg;
wire [4:0] DestRegReg;
wire [1:0] WBReg_s7;
wire HaltReg_s7;
MemWB s7 (
.MemOp(MemOp),
.ResultRType(ResultRType),
.WrReg(DestReg),
.WB(WBReg_s6),
.MemOpReg(MemOpReg),
.ResultRTypeReg(ResultRTypeReg),
.WrRegReg(DestRegReg),
.WBReg(WBReg_s7),
.clk(clk),
.reset(reset),
.Halt(HaltReg_s5),
.HaltReg(HaltReg_s7)
);

//////////////////HLT Logic/////////////
wire stop_clk;
assign clk= clock|stop_clk;
assign stop_clk = (HaltReg_s7)?(~RSM):(0);
//////////////////////////////////////

//wire [31:0] FResult;
stage5 s8 (
.MemOp(MemOpReg),
.ResultRType(ResultRTypeReg),
.DestReg(DestRegReg),
.WB(WBReg_s7),
.Result(InData),
.RegWrite(RegWrite),
.DestRegReg(WrReg),
.reset(reset));

assign RegisterContent = InData;
assign RegisterNo = WrReg;

////////////////////////////Forwarding Unit//////////////////////////////////


ForwardingUnit FU (.EX_MEM_Regwrite(WBReg_s5[1]), 
.EX_MEM_RegisterRd(WrRegReg),
.MEM_WB_Regwrite(WBReg_s7[1]),
.MEM_WB_RegisterRd(DestRegReg),
.ID_EX_RegisterRs(RsReg),
.ID_EX_RegisterRt(RtReg),
.ForwardA(ForwardA),
.ForwardB(ForwardB)
);


////////////////////////////Hazard Detection Unit//////////////////////////////////
//wire PCWrite, Pipe_stall,IF_ID_Write;

HazardUnit HU (.ID_EX_MemRead(MEMReg[2]),
.ID_EX_RegisterRt(RtReg),
.IF_ID_RegisterRs(InstReg[25:21]),
.IF_ID_RegisterRt(InstReg[20:16]),
.PCWrite(PCWrite),
.Pipe_stall(Pipe_stall),
.IF_ID_Write(IF_ID_Write),
.reset(reset)
);
//--------------------------------------------------------------------------------
////////////////////////////Control Hazard Detection and Forwarding Unit/////////////////////////////////

ForwardingUnit_ControlH CHDFU (
.ID_Inst(InstReg),
.EX_DestReg(WriteReg),
.EX_RegWrite(WBReg[1]),
.MEM_DestReg(WrRegReg),
.MEM_RegWrite(WBReg_s5[1]),
.WB_DestReg(DestRegReg),
.WB_RegWrite(WBReg_s7[1]),
.EX_MEM_MemRead(MEMReg_s5[2]),
.ForwardA(FwdA),
.ForwardB(FwdB),
.PCWrite(PCWrite),
.IF_ID_Write(IF_ID_Write),
.EX_Flush(Pipe_stall)
);

//--------------------------------------------------------------------------------


endmodule
