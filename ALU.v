`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:51 10/28/2015 
// Design Name: 
// Module Name:    ALU 
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
module ALU(ALUCon,DataA,DataB,Result,Flag);//Flag contains {Underflow, Overflow, div. by Zero}
    input [3:0] ALUCon;							// underflow yet to do
    input [31:0] DataA,DataB;
	 
	 parameter Flag_Width = 3;
	 
	 output [Flag_Width-1:0] Flag ;
	 reg [Flag_Width-1:0] Flag ;
	 
    output [31:0] Result;   
    reg [31:0] Result;
	 
  //  reg Zero;
    
	 //assign result = Result;
//    initial begin
//        Result <= 32'd0; //not necessary
//		  Flag <= {Flag_Width{0}}; //it is Important. It has to be initialized to zero
//    end
	 
    always@( ALUCon, DataA, DataB)
    begin : calculating_result
      case(ALUCon)
          4'b0000://and
             Result <= DataA&DataB;
          
          4'b0001://or
             Result <= DataA|DataB;
        
          4'b0010://add
			 begin
             Result <= DataA+DataB;
//				 if ((DataA[31] == 1'b1 && DataB[31] == 1'b1 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b0 && Result[31] == 1'b1))//overflow
//						Flag[1]<=1'b1;//
			 end    
			 //Multiply not allowed as it degrades throughput
//          4'b0011://multiply
//			 begin
//              Result <= DataA*DataB;
////				  if ((DataA[31] == 1'b1 && DataB[31] == 1'b1 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b0 && Result[31] == 1'b1))//overflow
////						Flag[1]<=1'b0;/////////////////
//			 end	  
          4'b0100://nor
              begin
                 Result[0] <= !(DataA[0]|DataB[0]);
                 Result[1] <= !(DataA[1]|DataB[1]);
                 Result[2] <= !(DataA[2]|DataB[2]);
                 Result[3] <= !(DataA[3]|DataB[3]);
                 Result[4] <= !(DataA[4]|DataB[4]);
                 Result[5] <= !(DataA[5]|DataB[5]);
                 Result[6] <= !(DataA[6]|DataB[6]);
                 Result[7] <= !(DataA[7]|DataB[7]);
                 Result[8] <= !(DataA[8]|DataB[8]);
                 Result[9] <= !(DataA[9]|DataB[9]);
                 Result[10] <= !(DataA[10]|DataB[10]);
                 Result[11] <= !(DataA[11]|DataB[11]);
                 Result[12] <= !(DataA[12]|DataB[12]);
                 Result[13] <= !(DataA[13]|DataB[13]);
                 Result[14] <= !(DataA[14]|DataB[14]);
                 Result[15] <= !(DataA[15]|DataB[15]);
                 Result[16] <= !(DataA[16]|DataB[16]);
                 Result[17] <= !(DataA[17]|DataB[17]);
                 Result[18] <= !(DataA[18]|DataB[18]);
                 Result[19] <= !(DataA[19]|DataB[19]);
					  Result[20] <= !(DataA[20]|DataB[20]);
                 Result[21] <= !(DataA[21]|DataB[21]);
                 Result[22] <= !(DataA[22]|DataB[22]);
                 Result[23] <= !(DataA[23]|DataB[23]);
                 Result[24] <= !(DataA[24]|DataB[24]);
                 Result[25] <= !(DataA[25]|DataB[25]);
                 Result[26] <= !(DataA[26]|DataB[26]);
                 Result[27] <= !(DataA[27]|DataB[27]);
                 Result[28] <= !(DataA[28]|DataB[28]);
                 Result[29] <= !(DataA[29]|DataB[29]);
                 Result[30] <= !(DataA[30]|DataB[30]);
                 Result[31] <= !(DataA[31]|DataB[31]);
              end
              
//			 4'b0101://divide
//			 begin
////				 Result <= DataA/DataB;
////				 if(DataB == 32'd0)
////						Flag[0] <= 1'b1;
//			 end
             
          4'b0110://sub
			 begin
             Result <= DataA-DataB;
//				 if ((DataA[31] == 1'b1 && DataB[31] == 1'b0 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b1 && Result[31] == 1'b1))//overflow
//						Flag[1]<=1'b1;//
			 end
			 
          4'b0111://slt
             Result <= DataA<DataB ? 1:0;
             
          4'b1000://sll
			 begin
//             Result <= (DataA<<DataB[5:0]); 
				 //DataB should be positive
				 if(DataB > 32'd32)
						Result <= 0;
				 else
						Result <= (DataA<<DataB[4:0]);//it cann't be shifted by large amt
          end   
			 
          4'b1001://srl
			 begin
//             Result <= (DataA>>DataB[5:0]);    
				 if(DataB > 32'd32)
						Result <= 0;
				 else
						Result <= (DataA>>DataB[4:0]);//it cann't be shifted by large amt
			 end
          default: //error
          begin
              $display("ALUERROR");
              Result <= 0;
          end
          
      endcase
    end
	 
	//assign Flag = ()
	 always @ (Result,ALUCon,DataA,DataB)
	 begin : setting_flag
		case (ALUCon)
		    4'b0010://add
			 begin
				 if ((DataA[31] == 1'b1 && DataB[31] == 1'b1 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b0 && Result[31] == 1'b1))//overflow
						Flag[1]<=1'b1;//
				 else
						Flag <= 3'b000;
			 end

//			 4'b0011://multiply
//			 begin
//				  if ((DataA[31] == 1'b1 && DataB[31] == 1'b1 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b0 && Result[31] == 1'b1))//overflow
//						Flag[1]<=1'b0;/////////////////
//				  else
//						Flag <= 3'b000;
//			 end
			 
//			 4'b0101://divide
//			 begin
////				 Result <= DataA/DataB;
////				 if(DataB == 32'd0)
////						Flag[0] <= 1'b1;
////				 else
////						Flag <= 3'b000;
//			 end
			 
			 4'b0110://sub
			 begin
				 if ((DataA[31] == 1'b1 && DataB[31] == 1'b0 && Result[31] == 1'b0) || (DataA[31] == 1'b0 && DataB[31] == 1'b1 && Result[31] == 1'b1))//overflow
						Flag[1]<=1'b1;//
				 else
						Flag <= 3'b000;
			 end
			 
			 default:
			 begin
				 Flag <= 3'b000;
			 end
		endcase
	 end

endmodule


