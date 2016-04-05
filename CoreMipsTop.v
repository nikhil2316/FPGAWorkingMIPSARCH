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
//RegData,

ipbar_op,
Port,
NMI,
NMI_ID,
NMI_ACK
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
	wire [31:0] RegData;
	wire core_clk;	//clk for "core" Mips
	
//debouncer debouncePB (
//    .clk(Master_clk), 
//    .PB(clk_PB), 
//    .PB_state(core_clk)
//    );

assign core_clk = clk_PB;///-----------TAKE CARE OF THIS----------------------////

wire [31:0] PC;
wire [31:0] RegisterContent;
wire [4:0] RegisterNo;

//Inst Mem
wire [31:0] Instruction;
InstMem InsTMEM (
  .clka(~core_clk), // input clka
  .wea(1'b0), // input [0 : 0] wea
  .addra(PC), // input [9 : 0] addra
  .dina(32'b1), // input [31 : 0] dina
  .douta(Instruction) // output [31 : 0] douta
);

//Data Mem
wire [3:0] MEMReg_s5;
wire [31:0] DataAddr, DataIn, DataOut;
wire DataMemWrite;
DataMem DATAMEM (
  .clka(~core_clk), // input clka
  .wea(DataMemWrite), // input [0 : 0] wea
  .addra(DataAddr), // input [6 : 0] addra
  .dina(DataOut), // input [31 : 0] dina
  .douta(DataIn) // output [31 : 0] douta
);

//CORE1 , MIPS Architecture, fmax = 118 MHz
output ipbar_op;
inout [31:0] Port;
input NMI;
input [1:0] NMI_ID;
output NMI_ACK;
Mips_Pip_CPU_Orig CORE1 (
    .clk(core_clk), 
    .RegisterContent(RegisterContent), 
    .RegisterNo(RegisterNo), 
    .PC(PC), 
    .Instruction(Instruction), 
    .DataAddr(DataAddr), 
    .DataIn(DataIn),
	 .DataOut(DataOut),
//	 .MEMReg_s5(MEMReg_s5),
	 .DataMemWrite(DataMemWrite),
    .reset(reset),
	 .RegAddr(RegAddr),
	 .RegData(RegData),
	 .ipbar_op(ipbar_op),
	 .Port(Port),
	 .NMI(NMI),
	 .NMI_ID(NMI_ID),
	 .NMI_ACK(NMI_ACK)
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
