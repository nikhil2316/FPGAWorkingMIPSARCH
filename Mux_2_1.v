`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:00 10/28/2015 
// Design Name: 
// Module Name:    Mux_2_1 
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
module Mux_2_1(
A,
B,
S,
Out
    );

input A,B,S;
output Out;
reg Out;

always @ (A,B,S) 
begin
	Out = (S)?B:A;
end

endmodule
