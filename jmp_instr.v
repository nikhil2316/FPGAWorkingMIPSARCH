`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:22:47 02/02/2016 
// Design Name: 
// Module Name:    jmp_instr 
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
module jmp_instr(
Inst, 
PCPlus4,
PCSrc,
JmpAddr,
ResumeAddr,
reset
    );

input [31:0] Inst;
input [31:0] PCPlus4, ResumeAddr;
input reset;

output PCSrc;
reg PCSrc;
output [31:0] JmpAddr;

//initial //PCSrc needs to be initialized to zero
//	PCSrc <= 1'b0;
	
always @ (Inst[31:26], reset)
begin
		if(reset)
			PCSrc <= 1'b0;
		else if (Inst[31:26] == 6'h2 || Inst[31:26] == 6'h3)
			PCSrc <= 1'b1;
		else
			PCSrc <= 1'b0;	
end

assign JmpAddr = (Inst[31:26] == 6'h2)?({{6{Inst[25]}},Inst[25:0]}):((Inst[31:26] == 6'h3)?(ResumeAddr):(PCPlus4));

endmodule
