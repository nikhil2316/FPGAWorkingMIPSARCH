`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:38 10/28/2015 
// Design Name: 
// Module Name:    Stage1 (Instruction Fetch)
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
module Stage1(
//Inputs
PCSrc, 	//to select bw PC+4 and BranchAddr
PCPlus4PlusOff, 	//BranchAddr
PCWrite,	 //if 0 PC value will not change 
JmpAddr, 	//if jmp instr., jmp to this Addr
ExceptionResumeAddr, 	//in case of internally generated exception, execute program residing at this addr
ChooseEPC, 	//if 1, choose ExceptionResumeAddr
PC_stage2, 	//value of PC in stage2, use when BTB predict incorrectly
WriteEntry, 	//tells wether info is in BTB or not, and if it is wether it needs to be changed
clk, 	//sync clk
reset,	//sync_reset

//Outputs
PCPlus4, //adjacent instr. addr 
FindinBTB, //wether brnch is find in BTB
taken, //wether branch taken or not by BTB
PC_out //Program Counter
    );
//Inputs
input [1:0] PCSrc;
input [2:0] WriteEntry;
input [31:0] PCPlus4PlusOff, PC_stage2;
input clk, PCWrite, ChooseEPC, reset;
input [31:0] JmpAddr,ExceptionResumeAddr;

//Outputs
output [31:0] PCPlus4, PC_out;
output FindinBTB,taken; 

//Internal Signals
reg [31:0] PC ;
wire [31:0] NextPC,NewPC,FOUR, FinalPC;
wire [3:0] ALU_add ;
wire [31:0] dummy;

assign PC_out = PC;

ALU s1 (.ALUCon(4'b0010),.DataA(PC),.DataB(32'b100),.Result(PCPlus4));

Mux32_2_1 s2 (.A((WriteEntry[2])?(PC_stage2+32'd4):(PCPlus4)),.B(PCPlus4PlusOff),.S(PCSrc[0]),.Out(NextPC));//nextPC takes care of branch or PC+4
	
wire [31:0] PC_predicted;

assign FinalPC = ((WriteEntry == 3'b000) && FindinBTB && taken )?(PC_predicted):((ChooseEPC == 1'b1)?(ExceptionResumeAddr):((PCSrc[1])?(JmpAddr):(NextPC)));

always @ (posedge clk)                                                                      
begin
	if(reset)
	begin
		PC <= 0;
	end
	else
	begin
		if(PCWrite == 1'b0)
			PC <= PC;
		else
			PC <= FinalPC;
	end
end

//---------------------------BTB---------------------------------------------------
Branch_Target_Buffer BTB (
.PC(PC),
.PC_ip(PC_stage2),
.PC_predicted_ip(PCPlus4PlusOff),
.taken_ip(PCSrc[0]),
.PC_predicted(PC_predicted),
.taken(taken),
.WriteEntry(WriteEntry&{3{PCWrite}}),
.FindinBTB(FindinBTB),
.clk(clk)
);

//---------------------------------------------------------------------------------
 
endmodule
