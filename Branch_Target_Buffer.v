`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:59 02/13/2016 
// Design Name: 
// Module Name:    Branch_Target_Buffer 
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
module Branch_Target_Buffer(
PC,
PC_ip,
PC_predicted_ip,
taken_ip,
PC_predicted,
taken,
WriteEntry,
FindinBTB,
clk
    );
	 
input [31:0] PC,PC_ip, PC_predicted_ip;
input clk, taken_ip;//WriteEntry tells that write this entry into BTB
input [2:0] WriteEntry;//[UsePCstage2,Noentry,Decision]
output [31:0] PC_predicted;
output taken, FindinBTB;

reg FindinBTB;
reg [65:0] LookUp [7:0];//{Valid Bit, PC, Predicted PC, Taken}

integer i;
integer CurrentLoc;// as 8 entries in LookUp
reg [32:0] Intermediate;
reg flag;
initial 
begin
		for(i=0;i<8;i=i+1)
		begin
			LookUp[i] = 66'd0;
			
		end
		//LookUp[0] = 66'h20000004800000020;
		CurrentLoc = 3'd0;
		Intermediate = 33'd0;
		FindinBTB = 1'b0;
		flag =0;
		i = 0;
end


always @ (PC, WriteEntry, PC_predicted_ip, taken_ip, PC_ip)
begin
	if (WriteEntry[1:0])
	begin

		if (WriteEntry[0])
		begin
			for(i=0;i<8;i=i+1)
			begin
				if(LookUp[i][65:33] == {1'b1, PC_ip})
				begin
					LookUp[i] = {1'b1, PC_ip, PC_predicted_ip, taken_ip};  //overwrite current decision
					//flag = 1'b1;
				end
			end
		end
		else if (WriteEntry[1])//no entry in BTB
		begin
			LookUp[CurrentLoc] = {1'b1, PC_ip, PC_predicted_ip, taken_ip}; 
   		CurrentLoc = CurrentLoc + 1; 
		end
		FindinBTB = 1'b0;
	end
	else
	begin
		FindinBTB = 1'b0;
		for(i=0;i<8;i=i+1)
		begin
			if (LookUp[i][65:33] == {1'b1, PC})
			begin
				Intermediate = LookUp[i][32:0];
				FindinBTB = 1'b1;
			end
		end
	end
end

//always @ (posedge WriteEntry)
//begin
//		//flag = 1'b0;
//		for(i=0;i<8;i=i+1)
//		begin
//			if(LookUp[i][65:33] == {1'b1, PC_ip})
//			begin
//				LookUp[i] = {1'b1, PC_ip, PC_predicted_ip, taken_ip};  //overwrite current decision
//				flag = 1'b1;
//			end	
//		end
//		if (flag == 1'b0)
//		begin
//			LookUp[CurrentLoc] = {1'b1, PC_ip, PC_predicted_ip, taken_ip}; 
//			CurrentLoc = CurrentLoc + 1; 
//		end
//		FindinBTB = 1'b0;
//end
assign {PC_predicted, taken} = Intermediate;

endmodule
