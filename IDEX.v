`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:52 10/29/2015 
// Design Name: 
// Module Name:    IDEX 
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
module IDEX(
PCPlus4,
A,
B,
SignExtImme,
Rt,
Rd,
Rs,
WB,
MEM,
EX,
ID_EX_Flush_excep,
PCPlus4Reg,
AReg,
BReg,
SignExtImmeReg,
RtReg,
RdReg,
RsReg,
WBReg,
MEMReg,
EXReg,
clk,
reset
    );

input [31:0] PCPlus4, A,B,SignExtImme;
input [4:0] Rt,Rd,Rs;
input clk, ID_EX_Flush_excep, reset;
input [3:0] EX;
input [3:0] MEM;
input [1:0] WB;

output [31:0] PCPlus4Reg,AReg,BReg,SignExtImmeReg;
output [4:0] RtReg,RdReg,RsReg;
output [3:0] EXReg;
output [3:0] MEMReg;
output [1:0] WBReg;
reg [31:0] PCPlus4Reg,AReg,BReg,SignExtImmeReg;
reg [4:0] RtReg,RdReg,RsReg;
reg [3:0] EXReg;
reg [3:0] MEMReg;
reg [1:0] WBReg;

always @ (posedge clk)
begin
	if(reset)
	begin
			PCPlus4Reg <= 0;
			EXReg <= 4'd0; //set control signals zero turn it in NOP
			MEMReg <= 4'd0;
			WBReg <= 2'd0;
	end
	else
	begin
		if(ID_EX_Flush_excep == 1'b1)
		begin
			PCPlus4Reg <= PCPlus4;
			AReg <= 32'b0; // these are put equal to zero to ensure no overflow
			BReg <= 32'b0;
			SignExtImmeReg <= 32'b0;
			RtReg <= Rt;
			RdReg <= Rd;
			RsReg <= Rs;
			EXReg <= 4'd0; //set control signals zero turn it in NOP
			MEMReg <= 4'd0;
			WBReg <= 2'd0;
		end
		else
		begin
			PCPlus4Reg <= PCPlus4;
			AReg <= A;
			BReg <= B;
			SignExtImmeReg <= SignExtImme;
			RtReg <= Rt;
			RdReg <= Rd;
			RsReg <= Rs;
			EXReg <= EX;
			MEMReg <= MEM;
			WBReg <= WB;
		end
	end
end
endmodule
