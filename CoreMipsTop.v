`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:55 03/08/2016 
// Design Name: 
// Module Name:    CoreMipsTop 
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
module CoreMipsTop
(
Master_clk,	//High Freq Clk.
clk_PB,	//clk from PUSHBUTTON or any Low freq clk
reset,	//sync reset for Processor

sf_e,		//LCD Signals
e,		
rs,
rw,
nibble,
RegAddrEN,  //0-> LCD will print RegisterContent coming from CORE1
		//1-> LCD will print content of Register mentioned by RegAddr
RegAddr,
RegData	
    );

	input Master_clk;		//100 MHz Clk "AH15"
	input clk_PB;	//PB -> "U8"
	input reset;	//PB -> "V8"
	
	//LCD
	input [4:0] RegAddr;	//DIP SW
	input RegAddrEN;	//DIP SW, Set it to 0 in starting.......
	
	output sf_e; 
	output e; 
	output rs; 
	output rw; 
	output [3:0] nibble; 
	output [31:0] RegData;
	wire core_clk;	//clk for "core" Mips
	
debouncer debouncePB (
    .clk(Master_clk), 
    .PB(clk_PB), 
    .PB_state(core_clk)
    );

//assign core_clk = clk_PB;

wire [31:0] PC;
wire [31:0] RegisterContent;
wire [4:0] RegisterNo;

//Inst Mem
reg [7:0] InstMem [0:47];	//12 Instruction could run (12*4 = 48)

always @ (posedge Master_clk)
begin
	if(reset)
	begin
	
		//Fill Inst Mem
	{InstMem[0], InstMem[1], InstMem[2], InstMem[3]} =32'b001000_00000_00101_00000_00000_000101;//r5=5+r0;  //addi		I
	{InstMem[4], InstMem[5], InstMem[6], InstMem[7]} =32'b001000_00101_00001_00000_00000_000100;//r1=4+r5;  //addi		I
	{InstMem[8], InstMem[9], InstMem[10], InstMem[11]} =32'b000000_00001_00101_00111_00000_100000;//r7=r1 + r5;  	R
	{InstMem[12], InstMem[13], InstMem[14], InstMem[15]} =32'b000000_00101_00001_00110_00000_100010;//r6=r5-r1;	 	R  NOP
	{InstMem[16], InstMem[17], InstMem[18], InstMem[19]} =32'b000000_00101_00111_00100_00000_100000;//r4=r7+r5;  //and	R
	////////////////////////////////////////////////////////////////////////////////////////////////////
	{InstMem[20], InstMem[21], InstMem[22], InstMem[23]} =32'b001101_00001_01000_00000_00000_000110;//r8=(r1|6);		I
	{InstMem[24], InstMem[25], InstMem[26], InstMem[27]} =32'b000000_00001_00101_01001_00000_101010;//r9=(r1<r5)?(1):(0);	R
	{InstMem[28], InstMem[29], InstMem[30], InstMem[31]} =32'b000000_00000_00000_00000_00000_100000;//r4=~(r1|r5); 
	end
end

wire [31:0] Instruction;
assign Instruction = {InstMem[PC + 0], InstMem[PC + 1], InstMem[PC + 2], InstMem[PC + 3]};

Mips_Pip_CPU_Orig CORE1 (
    .clk(core_clk), 
    .RegisterContent(RegisterContent), 
    .RegisterNo(RegisterNo), 
    .PC(PC), 
    .Instruction(Instruction), 
    .DataAddr(), 
    .Data(), 
    .reset(reset),
	 .RegAddr(RegAddr),
	 .RegData(RegData)
    );

wire Sign;
reg [3:0] Digit1;
reg [3:0] Digit2;

//LCD can Print 2 digit Numbers only
LCD_Controller LCD (
    .clk(Master_clk),  
    .sf_e(sf_e), 
    .e(e), 
    .rs(rs), 
    .rw(rw), 
    .nibble(nibble), 
    .Sign(Sign), 
    .Digit1(Digit1), 	//msb
    .Digit2(Digit2), 
    .StartPrinting(reset)
    );
	 
assign Sign = (RegAddrEN)?(RegData[31]):(RegisterContent[31]);

wire [31:0] Number = (RegAddrEN)?((Sign)?((~RegData)+1'b1):(RegData)):((Sign)?((~RegisterContent)+1'b1):(RegisterContent));
//Generation of Sign, Digit1 and Digit2 
always @ (Number[6:0])	//2 digit No
begin
	if(Number < 7'd10)
	begin
		Digit1 <= 4'd0;
		Digit2 <= Number[3:0];
	end
	else if(Number < 7'd20)
	begin
		Digit1 <= 4'd1;
		Digit2 <= Number - 7'd10;
	end
	else if(Number < 7'd30)
	begin
		Digit1 <= 4'd2;
		Digit2 <= Number - 7'd20;
	end
	else if(Number < 7'd40)
	begin
		Digit1 <= 4'd3;
		Digit2 <= Number - 7'd30;
	end
	else if(Number < 7'd50)
	begin
		Digit1 <= 4'd4;
		Digit2 <= Number - 7'd40;
	end
	else if(Number < 7'd60)
	begin
		Digit1 <= 4'd5;
		Digit2 <= Number - 7'd50;
	end
	else if(Number < 7'd70)
	begin
		Digit1 <= 4'd6;
		Digit2 <= Number - 7'd60;
	end
	else if(Number < 7'd80)
	begin
		Digit1 <= 4'd7;
		Digit2 <= Number - 7'd70;
	end
	else if(Number < 7'd90)
	begin
		Digit1 <= 4'd8;
		Digit2 <= Number - 7'd80;
	end
	else if(Number < 7'd100)
	begin
		Digit1 <= 4'd9;
		Digit2 <= Number - 7'd90;
	end
end

endmodule
