`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:09 01/13/2016 
// Design Name: 
// Module Name:    ForwardingUnit 
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
module ForwardingUnit(
EX_MEM_Regwrite,
EX_MEM_RegisterRd,
MEM_WB_Regwrite,
MEM_WB_RegisterRd,
ID_EX_RegisterRs,
ID_EX_RegisterRt,
ForwardA,
ForwardB

    );

input EX_MEM_Regwrite, MEM_WB_Regwrite;
input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt;

output [1:0] ForwardA, ForwardB;
reg [1:0] ForwardA, ForwardB;

//Forward A
always @ (EX_MEM_Regwrite, MEM_WB_Regwrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt)
begin
	if (EX_MEM_Regwrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs))
		ForwardA = 2'b10;
	else if (MEM_WB_Regwrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs) )
		ForwardA = 2'b01;
	else
		ForwardA = 2'b00;


end

//Forward B
always @ (EX_MEM_Regwrite, MEM_WB_Regwrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt)
begin
	if (EX_MEM_Regwrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt))
		ForwardB = 2'b10;
	else if (MEM_WB_Regwrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRt) )
		ForwardB = 2'b01;
	else
		ForwardB = 2'b00;


end

endmodule
