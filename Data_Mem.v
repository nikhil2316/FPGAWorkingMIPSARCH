`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:55 10/28/2015 
// Design Name: 
// Module Name:    Data_Mem 
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
module DATAMEM(MemWrite,MemRead,Addr,Wdata,Rdata);

input [31:0] Addr,Wdata;
input MemWrite,MemRead;

output [31:0] Rdata;
reg [31:0] Rdata;

reg [31:0] regfile[49:0];//50 32-bit registers

always@(Addr,Wdata,MemWrite,MemRead)
	if(MemWrite) begin 
		$display("Writing %d -> Addr: %d",Wdata,Addr);
		regfile[Addr]<=Wdata; //memory write
	end

always@(Addr,Wdata,MemWrite,MemRead)
	if(MemRead)
		Rdata <= regfile[Addr];//memory read


endmodule


