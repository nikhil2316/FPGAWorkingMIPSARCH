`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:43 10/29/2015 
// Design Name: 
// Module Name:    IFID 
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
module IFID(
//Inputs
PCPlus4, 	//Next Inst Addr
Inst,		//Inst at PC
IF_ID_Write,	//Update Reg's if 1
IF_ID_Flush_excep,	//Flush Inst if 1
FindinBTB,		//Brnch Entry is present in BTB
taken,	//Brnch is taken 
PCSrc,	//Decide when to flush inst i.e. insert Bubble
clk,	//sync clk
reset, //sync reset

//Outputs
PCPlus4Reg,		//PCplus4 Latched
InstReg,		//InstReg Latched
FindinBTBReg,		//FindinBTB Latched
takenReg		//takenReg Latched
    );
	 
input [31:0] PCPlus4,Inst;
input clk,IF_ID_Write,IF_ID_Flush_excep, FindinBTB, taken, reset;
input [2:0] PCSrc; //PCSrc[2] = BTB takes wrong branch so need to insert a bubble in stage 2

output [31:0] PCPlus4Reg, InstReg;
reg [31:0] PCPlus4Reg, InstReg;
output FindinBTBReg, takenReg;
reg FindinBTBReg, takenReg;

wire [31:0] Instruction;
 
assign Instruction = (IF_ID_Flush_excep || PCSrc[1] || PCSrc[0] || PCSrc[2])?(32'b000000_00000_00000_00000_00000_100000):(Inst);

always @ (posedge clk)
begin
	if(reset)
	begin
		PCPlus4Reg <= 32'b0;
		InstReg <= 32'b000000_00000_00000_00000_00000_100000;
		FindinBTBReg <= 1'b0;
		takenReg <= 1'b0;
	end
	else
	begin
		if(IF_ID_Write)
		begin
			PCPlus4Reg <= PCPlus4;
			InstReg <= Instruction;
			FindinBTBReg <= FindinBTB;
			takenReg <= taken;
		end
	end
end

endmodule
