`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:42 10/29/2015 
// Design Name: 
// Module Name:    EXMem 
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
module EXMem(
PCPlus4PlusOff,
Equal,
Result,
OutB,
WrReg,
WB,
MEM,
EX_Mem_Flush_excep,
PCPlus4PlusOffReg,
EqualReg,
ResultReg,
OutBReg,
WrRegReg,
WBReg,
MEMReg,
clk,
reset
    );

input [31:0] PCPlus4PlusOff,Result,OutB;
input Equal,clk, EX_Mem_Flush_excep,reset;
input [4:0] WrReg;
input [3:0] MEM;
input [1:0] WB;

output [31:0] PCPlus4PlusOffReg,ResultReg,OutBReg;
output EqualReg;
output [4:0] WrRegReg;
output [3:0] MEMReg;
output [1:0] WBReg;

reg [31:0] PCPlus4PlusOffReg,ResultReg,OutBReg;
reg EqualReg;
reg [4:0] WrRegReg;
reg [3:0] MEMReg;
reg [1:0] WBReg;

always @ (posedge clk)
begin
	if(reset)
	begin
			PCPlus4PlusOffReg <=0;
			ResultReg <= 0;
			OutBReg <= 0;
			EqualReg <= 0;
			WrRegReg <= 0;
			MEMReg <= 4'd0;
			WBReg <= 2'd0;
	end
	else
	begin
		if (EX_Mem_Flush_excep == 1'b1)
		begin
			PCPlus4PlusOffReg <= PCPlus4PlusOff;
			ResultReg <= Result;
			OutBReg <= OutB;
			EqualReg <= Equal;
			WrRegReg <= WrReg;
			MEMReg <= 4'd0;
			WBReg <= 2'd0;
		end
		else
		begin
			PCPlus4PlusOffReg <= PCPlus4PlusOff;
			ResultReg <= Result;
			OutBReg <= OutB;
			EqualReg <= Equal;
			WrRegReg <= WrReg;
			MEMReg <= MEM;
			WBReg <= WB;
		end
	end
end

endmodule
