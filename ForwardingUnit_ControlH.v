`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:35 01/16/2016 
// Design Name: 
// Module Name:    ForwardingUnit_ControlH 
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
module ForwardingUnit_ControlH(
ID_Inst,
EX_DestReg,
EX_RegWrite,
MEM_DestReg,
MEM_RegWrite,
WB_DestReg,
WB_RegWrite,
EX_MEM_MemRead,
ForwardA,
ForwardB,
PCWrite,
IF_ID_Write,
EX_Flush
    );

input [31:0] ID_Inst;
input [4:0] EX_DestReg, MEM_DestReg, WB_DestReg;
input WB_RegWrite, MEM_RegWrite, EX_RegWrite, EX_MEM_MemRead;

output [1:0] ForwardA, ForwardB;
output PCWrite, IF_ID_Write, EX_Flush; 
reg [1:0] ForwardA, ForwardB;
reg PCWrite, IF_ID_Write, EX_Flush;

wire Branch;
assign Branch = (ID_Inst[31:26] == 6'b000100 || ID_Inst[31:26] == 6'b000101)?(1'b1):(1'b0);

wire [4:0] Rs,Rt;
assign Rs = ID_Inst[25:21];
assign Rt = ID_Inst[20:16];

always @ (ID_Inst,EX_DestReg, MEM_DestReg, WB_DestReg, WB_RegWrite, MEM_RegWrite, EX_RegWrite, EX_MEM_MemRead)
	if(Branch && (Rs == EX_DestReg || Rt == EX_DestReg)&& EX_DestReg != 0 && EX_RegWrite)
	begin
		//stall
		ForwardA <= 2'b00;
		ForwardB <= 2'b00;
		PCWrite <= 0;
		IF_ID_Write <= 0;
		EX_Flush <= 1;
	end
	else
	begin
		PCWrite <= 1;
		IF_ID_Write <= 1;
		EX_Flush <= 0;
		//Forward A
		if(Branch && (Rs == MEM_DestReg)&& MEM_DestReg != 0 && MEM_RegWrite)
		begin
			ForwardA <= 2'b10;
			if(EX_MEM_MemRead)
			begin
				//stall
				PCWrite <= 0;
				IF_ID_Write <= 0;
				EX_Flush <= 1;
				ForwardA <= 2'b00;
			end
		end
		else if (Branch && (Rs == WB_DestReg)&& WB_DestReg != 0 && WB_RegWrite)
			ForwardA <= 2'b01;
		
		else
			ForwardA <= 2'b00;
		
		//Forward B
		if(Branch && (Rt == MEM_DestReg)&& MEM_DestReg != 0 && MEM_RegWrite)
		begin
			ForwardB <= 2'b10;
			if(EX_MEM_MemRead)
			begin
				//stall
				PCWrite <= 0;
				IF_ID_Write <= 0;
				EX_Flush <= 1;
				ForwardB <= 2'b00;
			end
		end
		
		else if (Branch && (Rt == WB_DestReg)&& WB_DestReg != 0 && WB_RegWrite)
			ForwardB <= 2'b01;
			
		else
			ForwardB <= 2'b00;
	end

endmodule
