`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:01 10/30/2015 
// Design Name: 
// Module Name:    NextAddGen 
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
module NextAddGen(
Equal,
Branch,
FindinBTB,
taken,
PCSrc,
WriteEntry,
Pipe_stall,
reset
    );
	 
input Equal, FindinBTB, Pipe_stall, taken/*from BTB*/, reset;
input [1:0] Branch;

output PCSrc;
output [2:0]  WriteEntry;
reg PCSrc;
reg [2:0]  WriteEntry;//{Use_PC_Stage2,NoEntry,W.Decision} NoEntry=1 no entry in BTB thats why writeentry signal
													  //Decision = 1  so wrongdecision , Use PC_stage2 when btb takes the branch which should not be taken
initial
begin
	PCSrc <= 1'b0;
	WriteEntry <= 3'b000;
end	
always @ (Equal,Branch, FindinBTB, taken, Pipe_stall,reset)
begin
	if((!Branch[0])|reset)
	begin
		PCSrc <= 1'b0;
		WriteEntry <= 3'b000;
	end
	else if (!Branch[1])// its beq
	begin
		
		//PCSrc <= (Equal)?(1'b1):(1'b0);
		if(!FindinBTB)
		begin
			PCSrc <= (Equal)?(1'b1):(1'b0);//no entry in BTB
			WriteEntry <= (Pipe_stall)?(3'b000):(3'b010);
		end
		else
		begin
			if(taken == Equal) //BTB take correct decision
			begin
				PCSrc <= 1'b0;
				WriteEntry <= 3'b000;
			end
			else // BTB take incorrect decision
			begin
				PCSrc <= (Equal)?(1'b1):(1'b0);
				WriteEntry[1:0] <= (Pipe_stall)?(2'b00):(2'b01);
				
				WriteEntry[2] <= (taken)?(1'b1):(1'b0);//if br taken is wrong so use pcstage2 to come to correct pc
			end
		end
		
	end
	else if (Branch[1]) //its bne
	begin
		//PCSrc <= (Equal)?(1'b0):(1'b1);
		if(!FindinBTB)
		begin
			PCSrc <= (Equal)?(1'b0):(1'b1);//no entry in BTB
			WriteEntry <= (Pipe_stall)?(3'b000):(3'b010);//means if Pipe_stall no WriteEntry
		end
		else
		begin
			if(taken != Equal) //BTB take correct decision
			begin
				PCSrc <= 1'b0;
				WriteEntry <= 3'b000;
			end
			else // BTB take incorrect decision
			begin
				PCSrc <= (Equal)?(1'b0):(1'b1);
				WriteEntry[1:0] <= (Pipe_stall)?(2'b00):(2'b01);
				
				WriteEntry[2] <= (taken)?(1'b1):(1'b0);//if br taken is wrong so use pcstage2 to come to correct pc
			end
		end
	end
	else
	begin
		PCSrc <= 1'b0;
		WriteEntry <= 3'b000;
	end
end

endmodule
