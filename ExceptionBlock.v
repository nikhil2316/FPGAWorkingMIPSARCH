`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:55 02/03/2016 
// Design Name: 
// Module Name:    ExceptionBlock 
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
module ExceptionBlock(
Flag_EX,
Flag_ID,
PCInterrupted,
EPC,
Cause,
EX_Mem_Flush,
ID_EX_Flush,
IF_ID_Flush,
ChooseEPC,
reset
    );

parameter Flag_Width = 3;
input [Flag_Width-1:0] Flag_EX;
input Flag_ID, reset/*{UndefInst}*/;
input [31:0] PCInterrupted;

output [31:0] EPC;
output Cause;
output EX_Mem_Flush, ID_EX_Flush, IF_ID_Flush;
output ChooseEPC;
//reg [31:0] EPC;
reg Cause;
reg EX_Mem_Flush, ID_EX_Flush, IF_ID_Flush;
reg ChooseEPC;

wire [31:0] PcInterruptedAct;
//assign PcInterruptedAct = PCInterrupted - 32'd4;
wire [3:0] ALU_sub;
wire [31:0] FOUR;

assign ALU_sub = 4'b0110;
assign FOUR = 32'b100;

ALU s1 (.ALUCon(ALU_sub),.DataA(PCInterrupted),.DataB(FOUR),.Result(EPC));

//initial
//begin
//	EX_Mem_Flush <= 1'b0;//0-> dont flush
//	ID_EX_Flush <= 1'b0;
//	IF_ID_Flush <= 1'b0;
//	
//	//EPC <= 32'bx;
//	Cause <= 1'bx;
//	ChooseEPC <= 1'b0; //dont choose EPC
//end

always @ (Flag_EX, Flag_ID, PcInterruptedAct,reset)
begin
	if(reset)
	begin
		EX_Mem_Flush <= 1'b0;//0-> dont flush
		ID_EX_Flush <= 1'b0;
		IF_ID_Flush <= 1'b0;
	
	//EPC <= 32'bx;
		Cause <= 1'bx;
		ChooseEPC <= 1'b0; //dont choose EPC
	end
	else if (Flag_EX[1] == 1'b1) // overflow
	begin
		EX_Mem_Flush <= 1'b1;/////////////////
		ID_EX_Flush <= 1'b1;
		IF_ID_Flush	<= 1'b1;
		//flush all
		//EPC <= PcInterruptedAct;
		Cause <= 1'b1;
		ChooseEPC <= 1'b1;///
	end
	else if (Flag_ID == 1'b1)//undef_inst
	begin
		EX_Mem_Flush <= 1'b0;/////////////////
		ID_EX_Flush <= 1'b1;
		IF_ID_Flush	<= 1'b1;
		//flush all but EX_Mem
		//EPC <= PcInterruptedAct;
		Cause <= 1'b0;
		ChooseEPC <= 1'b1;///
	end
	else
	begin
		EX_Mem_Flush <= 1'b0;
		ID_EX_Flush <= 1'b0;
		IF_ID_Flush	<= 1'b0;
		
	//	EPC <= 32'bx;
		Cause <= 1'bx;
		ChooseEPC <= 1'b0;
	end
end

endmodule
