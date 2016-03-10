`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:53 10/28/2015 
// Design Name: 
// Module Name:    Inst_Mem 
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
module Inst_Mem(
PC,
Inst
    );

parameter MEM_SIZE = 32'd511;
output [31:0] Inst;
input [31:0] PC;

//reg [31:0] regfile[511:0];
reg [7:0] regfile[0:MEM_SIZE-1]; //Byte Addressable
assign Inst = {regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]};

endmodule


