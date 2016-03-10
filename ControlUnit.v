`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:31 10/30/2015 
// Design Name: 
// Module Name:    ControlUnit 
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

module ControlUnit(
Inst,
Pipe_stall,
Branch,
RegWrite,
ALUSrc,
ALUOp,
RegDst,
MemW,
MemR,
MemToReg,
UndefInst
    );
	 
input [31:0] Inst;
input Pipe_stall;

output RegWrite,ALUSrc,RegDst,MemW,MemR,MemToReg,UndefInst;
output [1:0] ALUOp,Branch;

reg UndefInst;
//reg PCSrc,RegWrite,ALUSrc,RegDst,MemW,MemR,MemToReg;
//reg [1:0] ALUOp;

reg [8:0] CFlag;

assign {Branch[0],RegWrite,ALUSrc,ALUOp,RegDst,MemW,MemR,MemToReg} = CFlag;
assign Branch[1] = (Inst[31:26]==6'b000100)?(1'b0):((Inst[31:26]==6'b000101)?(1'b1):(1'bx));//This finds wether its beq or bne
`define RType 6'd0

always @ (Inst, Pipe_stall)
begin
	if(Pipe_stall == 1'b1)
	begin
		
		if((Inst[31:26]==6'b000100) || (Inst[31:26]==6'b000101))
			CFlag <= {1'b1,8'd0};
		else
			CFlag <= {1'b0,8'd0};
		UndefInst <= 1'b0;
	end
	else if(Inst[31:26] == `RType) //RType Inst.
	begin
		CFlag <= 9'b0_1_0_00_1_0_0_0;	
		UndefInst <= 1'b0;
	end
	else
	begin
			casex(Inst[31:26])
				6'b00_1000 ://addi 
				begin
								CFlag <= 9'b0_1_1_01_0_0_0_0;
								UndefInst <= 1'b0;
				end
				6'b00_0100 ://beq 
				begin
								CFlag <= 9'b1_0_x_xx_x_0_0_x;
								UndefInst <= 1'b0;
				end
				6'b00_0101 ://bne
				begin
								CFlag <= 9'b1_0_x_xx_x_0_0_x;
								UndefInst <= 1'b0;
				end
				6'b10_0011 ://lw 
				begin
								CFlag <= 9'b0_1_1_01_0_0_1_1;
								UndefInst <= 1'b0;
				end
				6'b00_1101 ://ori 
				begin
								CFlag <= 9'b0_1_1_10_0_0_0_0;
								UndefInst <= 1'b0;
				end
				6'b10_1011 ://sw 
				begin
								CFlag <= 9'b0_0_1_01_x_1_0_1;
								UndefInst <= 1'b0;
				end
				default://undefined Instruction
				begin
								UndefInst <= 1'b1;
				end
			endcase	
	end
end



endmodule
