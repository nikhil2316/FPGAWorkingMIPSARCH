`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:13 03/04/2016 
// Design Name: 
// Module Name:    LCD_Controller 
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
module LCD_Controller(
clk,
sf_e,
e,
rs,
rw,
nibble,
Sign,
Digit1, //Data to be printed 
Digit2,
StartPrinting
 );
 
input clk;//pin C9 is 50 MHz on board clk
input [3:0] Digit1,Digit2;//max 2 digits
input StartPrinting, Sign;

output sf_e; //1 LCD access 
output e; //enable (1)
output rs; //Register Select (1 data bits for R/W)
output rw; //Read/Write, 1/0
output [3:0] nibble; //to form a nibble
wire [5:0] code;

LCDAdvanced LCD(
.clk(clk),//Uncertainity
.sf_e(sf_e),
.e(e),
.rs(rs),
.rw(rw),
.nibble(nibble),
.Sign(Sign),
.Digit1(Digit1), //Data to be printed
.Digit2(Digit2),
.Disable(StartPrinting),
.count_Debug(code)
    );

endmodule
