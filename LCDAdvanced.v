`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:58 03/02/2016 
// Design Name: 
// Module Name:    LCDAdvanced 
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
module LCDAdvanced(
clk,
sf_e,
e,
rs,
rw,
nibble,
Sign,
Digit1, //Data to be printed,
Digit2,
Disable,
count_Debug
    );
	
input clk;//pin C9 is 50 MHz on board clk
input [3:0] Digit1, Digit2;//max 2 digits
input Disable, Sign;

output reg sf_e; //1 LCD access 
output reg e; //enable (1)
output reg rs; //Register Select (1 data bits for R/W)
output reg rw; //Read/Write, 1/0
output reg [3:0] nibble; //to form a nibble
output [5:0] count_Debug;

reg [26:0]  count=0; //27 bit count, 0-(128M-1), around 2.68 sec to count all at 50 MHz
assign count_Debug = count[26:21];

reg [5:0] code; //6 bit different signals to give out 
reg refresh; // refresh LCD rate @ 25Hz

always @ (posedge clk)
begin
	if(Disable)
	begin
		
		sf_e <= 1;
		{e, rs, rw, nibble } <= 0;
		count <= 0;
		
	end
	else
	begin
		count <= count+1;
		
		case (count[26:21])	///[26:21]
		
		//power on init can be carried out before this loop to avoid the flicker
		0: code <= 6'h03; //power on init sequence
		1: code <= 6'h03; //this is needed atleast once
		2: code <= 6'h03; //when LCD's powered on
		3: code <= 6'h02; //it flickers existing char display
		
		//Table 5-3 Function Set
		//send 00 and upper nibble 0010, then 00 and lower nibble 10xx
		4: code <= 6'h02; //Function Set, upper nibble 0010
		5: code <= 6'h08; //lower nibble 1000 (10xx)
		
		//Table 5-3, Entry mode 
		//send 00 and upper nibble 0000, then 00 and lower nibble  0 1 I/D S
		//last 2 bits of lower nibble : I/D bit (Incr: 1, Decr: 0) , S bit (Shift 1, 0 no)
		6: code <= 6'h00; // see table, upper nibble 0000, then lower nibble :
		7: code <= 6'h06; // 0110 : Incr, Shift Disabled
		
		//Table 5-3, Display On/Off
		//send 00 and upper nibble 0000, then 00 and lower nibble 1DCB:
		//D: 1, show char represented by code in DDR, 0 dont, but code remains
		//C: 1, show cursor, 0 dont
		//B: 1, cursor blinks if shown, 0 dont blink if shown
		8: code <= 6'h00; //Display On/Off, upper nibble 0000
		9: code <= 6'h0C; //lower nibble 1100 (1 D C B)
		
		//Table 5-3, clear display, 00 and upper nibble 0000, 00 and lower nibble 0001
		10: code <= 6'h00; // clear display, 00 and upper nibble 0000
		11: code <= 6'h01; // then 00 and lower nibble 0001
		
		//character are then given out, the cursor will advance to right 
		//Table 5-3, write data to dd_ram or (cg_ram)
		//Fig 5-4, 'H', send 10 and upper nibble 0100, then 10 and lower nibble 1000
		12: code <= 6'h22; //'+' or '-' high nibble Sign->0 '+'
		13: code <= {2'b10,1'b1,Sign,~Sign,1'b1}; //'+' or '-' low nibble
		//Digit1
		14: code <= 6'h23; // high nibble
		15: code <= {2'b10, Digit1}; // low nibble 
		//Digit2
		16: code <= 6'h23; // high nibble
		17: code <= {2'b10, Digit2}; //low nibble 
//		16: code <= 6'h23; //'0' or '1' high nibble
//		17: code <= {2'b10, 3'b000, Din[3]}; //'0' or '1' low nibble 
//		18: code <= 6'h23; //'0' or '1' high nibble
//		19: code <= {2'b10, 3'b000, Din[2]}; //'0' or '1' low nibble 
//		20: code <= 6'h23; //'0' or '1' high nibble
//		21: code <= {2'b10, 3'b000, Din[1]}; //'0' or '1' low nibble 
//		22: code <= 6'h23; //'0' or '1' high nibble
//		23: code <= {2'b10, 3'b000, Din[0]}; //'0' or '1' low nibble  
		
		//Table 5-3, set DD-ram (DDR) address
		//position cursor onto start of 2nd line
		//send 00 and upper nibble 1???, ??? is the highest 3 bits of the DDR
		//address to move the cursor to , then 00 and lower 4 bits of addr
		//so ??? is 100 and then 0000 for h40
//		24: code <= 6'b001100; //pos cursor to 2nd line up
//		25: code <= 6'b000000; //lower nibble h0
		18: code <= 6'b001100; //pos cursor to 2nd line up
		19: code <= 6'b000000; //lower nibble h0
		
//		//character are then given out, the cursor will advance to right 
//		26: code <= 6'h25; //'W' high nibble
//		27: code <= 6'h27; //'W' low nibble 
//		28: code <= 6'h26; //'o'
//		29: code <= 6'h2F;
//		30: code <= 6'h27; //'r'
//		31: code <= 6'h22; 
//		32: code <= 6'h26; //'l'
//		33: code <= 6'h2C;
//		34: code <= 6'h26; //'d'
//		35: code <= 6'h24;
//		36: code <= 6'h22; //'!'
//		37: code <= 6'h21;
		
		//Table 5-3 , read  Busy FLag and Address
		//send 01  BF (Busy Flag) xxx, then 01xxxx
		//idling 
		default : code <= 6'h10; //the rest unused time 
		
		endcase
		
		//refresh enable the led when bit 20 of the count is 1
		//it flips when counted upto 1M and flips again after another 1M
		refresh <= count[20]; //20 //flip rate around 24 Hz (1/f = 2^21*20ns)
		sf_e <= 1;
		{e, rs, rw, nibble } <=  {refresh, code};
	end
end //always


endmodule
