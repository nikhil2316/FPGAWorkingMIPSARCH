`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:49:23 01/14/2016 
// Design Name: 
// Module Name:    HazardUnit 
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
module HazardUnit(
ID_EX_MemRead,
ID_EX_RegisterRt,
IF_ID_RegisterRs,
IF_ID_RegisterRt,
PCWrite,
Pipe_stall,
IF_ID_Write,
reset
    );

input ID_EX_MemRead, reset;
input [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt, ID_EX_RegisterRt;

output PCWrite, Pipe_stall, IF_ID_Write;
reg PCWrite, Pipe_stall, IF_ID_Write;

always @ (ID_EX_MemRead, IF_ID_RegisterRs, IF_ID_RegisterRt, reset)
begin
	if(reset)
	begin
			PCWrite <= 1;
			Pipe_stall <= 0;
			IF_ID_Write <= 1;
	end
	else if(ID_EX_MemRead && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt)))
		begin
			PCWrite <= 0;
			Pipe_stall <= 1;
			IF_ID_Write <= 0;
		end
	else
		begin
			PCWrite <= 1;
			Pipe_stall <= 0;
			IF_ID_Write <= 1;
		end
end
endmodule
