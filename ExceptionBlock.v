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
PCInterruptedinEX,
PCInterruptedinID,
EPC,
Cause,
EX_Mem_Flush,
ID_EX_Flush,
IF_ID_Flush,
ChooseEPC,
clk,
reset,
Excep_IntAddr,
NMI,
NMI_ID
    );
//EPC is ResumeAddr-----------
parameter Flag_Width = 3;
`include "ExceptionInterruptHandlerParameters.v"
input [Flag_Width-1:0] Flag_EX;
input Flag_ID, reset/*{UndefInst}*/, clk ,NMI;
input [31:0] PCInterruptedinEX,PCInterruptedinID;
input [1:0] NMI_ID;

output [31:0] EPC, Excep_IntAddr;
output Cause;
output EX_Mem_Flush, ID_EX_Flush, IF_ID_Flush;
output ChooseEPC;
reg [31:0] EPC,EPCReg, Excep_IntAddr;
reg Cause;
reg EX_Mem_Flush, ID_EX_Flush, IF_ID_Flush;
reg ChooseEPC;

reg [31:0] PCInterruptedinEXLatched,PCInterruptedinIDLatched;

always @ (negedge clk)
begin
	PCInterruptedinEXLatched <= PCInterruptedinEX;
	PCInterruptedinIDLatched <= PCInterruptedinID;
end

	
always @ ( Flag_EX[1], Flag_ID, reset, NMI, NMI_ID)
begin
	if(reset)
	begin
		EX_Mem_Flush <= 1'b0;//0-> dont flush
		ID_EX_Flush <= 1'b0;
		IF_ID_Flush <= 1'b0;
	
		EPCReg <= 32'd0;
		Cause <= 1'bx;
		ChooseEPC <= 1'b0; //dont choose EPC
		Excep_IntAddr <=32'd0;
	end
	else if (NMI)
	begin
		EX_Mem_Flush <= 1'b1;/////////////////
		ID_EX_Flush <= 1'b1;
		IF_ID_Flush	<= 1'b1;
		//flush all
		EPCReg <= PCInterruptedinEXLatched - 4'd4; // This instruction we might want to restart
		Cause <= 1'bx;
		ChooseEPC <= 1'b1;///
		Excep_IntAddr <= (NMI_ID == 2'b00)?(INT_00):((NMI_ID == 2'b01)?(INT_01):((NMI_ID == 2'b10)?(INT_10):(INT_11)));
	end
	else if (Flag_EX[1] == 1'b1) // overflow
	begin
		EX_Mem_Flush <= 1'b1;/////////////////
		ID_EX_Flush <= 1'b1;
		IF_ID_Flush	<= 1'b1;
		//flush all
		EPCReg <= PCInterruptedinEXLatched - 4'd4; // This instruction we might want to restart
		Cause <= 1'b1;
		ChooseEPC <= 1'b1;///
		Excep_IntAddr <= EXP_OVFLOW;
	end
	else if (Flag_ID == 1'b1)//undef_inst
	begin
		EX_Mem_Flush <= 1'b0;/////////////////
		ID_EX_Flush <= 1'b1;
		IF_ID_Flush	<= 1'b1;
		//flush all but EX_Mem
		EPCReg <= PCInterruptedinIDLatched;//at PCInterruptedinID - 4'd4 , UndefInst will be present , we dont want to run this inst again as this in an undef inst
		Cause <= 1'b0;
		ChooseEPC <= 1'b1;///
		Excep_IntAddr <=  EXP_UNDEF;
	end
	else
	begin
		EX_Mem_Flush <= 1'b0;
		ID_EX_Flush <= 1'b0;
		IF_ID_Flush	<= 1'b0;
		
		//EPC <= EPC;
		Cause <= 1'bx;
		ChooseEPC <= 1'b0;
	end
end

always @ (posedge clk)
	EPC <= EPCReg;



endmodule
