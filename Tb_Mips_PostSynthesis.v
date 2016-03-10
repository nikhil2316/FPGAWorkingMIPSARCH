`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:08:37 03/06/2016
// Design Name:   Mips_Pip_CPU
// Module Name:   E:/Xilinx/BTP MIPS ARCHITECTURE/MIPS_Pip/MipsFPGATBPostSynthesis.v
// Project Name:  MIPS_Pip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mips_Pip_CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Tb_Mips_PostSynthesis;

	// Inputs
reg clk, reset;
wire [31:0] Instruction, Data;

wire [31:0] RegisterContent;
wire [4:0] RegisterNo;
wire [31:0]  DataAddr;

wire [31:0] PCPlus4Reg,InstReg;
wire FindinBTBReg, takenReg;

reg [4:0] RegAddr;
wire [31:0] RegData;

wire [31:0] PCPlus4Reg_s3,AReg,BReg,SignExtImmeReg;
wire [4:0] RtReg,RdReg,RsReg;
wire [1:0] WBReg;
wire [3:0] MEMReg;
wire [3:0] EXReg;

wire [31:0] PCPlus4PlusOffReg/*,ResultReg*/,B_Reg;
wire EqualReg;
wire [4:0] WrRegReg;
wire [3:0] MEMReg_s5;
wire [1:0] WBReg_s5;

wire [31:0] MemOpReg,ResultRTypeReg;
wire [4:0] DestRegReg;
wire [1:0] WBReg_s7;
wire [4:0] WrReg;
wire [31:0] InData;
wire WE;
wire [1:0] FwdA, FwdB;

	parameter MEM_SIZE = 32'd512;// Inst Mem size
   parameter ExceptionAddr = MEM_SIZE - 32'd120;//leaving last 30 inst addresses
	
	wire [31:0] PCOut;
	wire [31:0] Inst;
	
Mips_Pip_CPU Debug (
    .clk(clk), 
    .RegisterContent(RegisterContent), 
    .RegisterNo(RegisterNo), 
    .PC(PCOut), 
    .Instruction(Instruction), 
    .DataAddr(DataAddr), 
    .Data(Data), 
    .reset(reset), 
    .PCPlus4Reg(PCPlus4Reg), 
    .InstReg(InstReg), 
    .FindinBTBReg(FindinBTBReg), 
    .takenReg(takenReg), 
    .PCPlus4Reg_s3(PCPlus4Reg_s3), 
    .AReg(AReg), 
    .BReg(BReg), 
    .SignExtImmeReg(SignExtImmeReg), 
    .RtReg(RtReg), 
    .RdReg(RdReg), 
    .RsReg(RsReg), 
    .WBReg(WBReg), 
    .MEMReg(MEMReg), 
    .EXReg(EXReg), 
	 .WrReg(WrReg),.InData(InData),.WE(WE),.FwdA(FwdA), .FwdB(FwdB),
    .PCPlus4PlusOffReg(PCPlus4PlusOffReg), 
    .B_Reg(B_Reg), 
    .EqualReg(EqualReg), 
    .WrRegReg(WrRegReg), 
    .MEMReg_s5(MEMReg_s5), 
    .WBReg_s5(WBReg_s5), 
    .MemOpReg(MemOpReg), 
    .ResultRTypeReg(ResultRTypeReg), 
    .DestRegReg(DestRegReg), 
    .WBReg_s7(WBReg_s7), 
    .RegAddr(RegAddr), 
    .RegData(RegData)
    );
	 
	integer i, clk_cycle;
	reg [31:0] PC;
	
	reg [7:0] regfile[0:MEM_SIZE-1];
	assign Instruction =  {regfile[PCOut],regfile[PCOut+1],regfile[PCOut+2],regfile[PCOut+3]};
	
	initial
	begin : clk_initialization
		clk=1;
		clk_cycle =0;
	end
	
	parameter T = 30;
	
	always 
	begin : clk_generator
		#(T/2) clk = ~clk;
	end
	
	always @(posedge clk)
	begin : to_print_clk_cycle_no
		clk_cycle = clk_cycle+1;
	//	$display("------------------------------Clk_Cycle = %d (- 2)------------------------------", clk_cycle);
	end
	
	initial 
	begin : main_block
	PC = 32'd0;
//	uut.s6.s0.regfile[0]=32'd1;
//--------------------------------------Load Inst. in Mem. at PC-------------------------------------------
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00000_00001_00000_100000;//r1=r0+r0;  //4
//	PC=PC+4;
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b100011_00000_00010_00000_00000_000000;//r2 = Memory[0]; //5
//	PC=PC+4;
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00010_00100_00000_100000;//r4=r2+r0; //7
//	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b001000_00000_00101_00000_00000_000101;//r5=5+r0;  
	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00101_00101_00001_00000_100000;//r1=r5+r5;  
	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00000_00000_00000_100000;//NOP  
	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00001_00101_00100_00000_100000;//r4=r1+r5;  
	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00000_00000_00000_100000;//NOP  
	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00000_00000_00000_100000;//NOP  
	PC=PC+4;
   ///////////////////////////////////////////////////////////////////////////////////////////////
	//                        |     IF    |    ID    |    EX    |    MEM   |    WB					//
	//                        _----- _____----- _____----- _____----- _____-----_____				//
	//																															//
	//           nextPC_ready|PC    Inst|Inst  Ctrl|Ctrl  Rslt|Rslt M_W&R|M_W&R   WB|				//
	///////////////////////////////////////////////////////////////////////////////////////////////
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	initial
	begin : reset_block
		reset=1;
		#(2*T) reset=0;
	end
	
	initial
	begin : terminator
		integer i;
		//used by reset
		#100;
		//Instr Execution
		RegAddr = 5'd5;
		for(i=1;i<=10;i=i+1)
		begin
			#(1*T);
			$stop;
		end
	end
endmodule

