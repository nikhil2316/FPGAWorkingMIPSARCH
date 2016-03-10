`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:36 10/28/2015 
// Design Name: 
// Module Name:    Mux32_2_1 
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
module Mux32_2_1(
A,
B,
S,
Out
    );

input [31:0] A,B;
input S;

output [31:0] Out;
reg [31:0] Out;

always @ (A,B,S)
begin
	Out = (S)?B:A;
end
endmodule
