`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:08:37 03/06/2016
// Design Name:   Mips_Pip_CPU
// Module Name:   E:/Xilinx/BTP MIPS ARCHITECTURE/MIPS_Pip/MipsFPGATBPostSynthesis.v
// Project Name:  MIPS_Pip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mips_Pip_CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TBforMips;

	// Inputs
	reg clk, reset;

	parameter MEM_SIZE = 32'd512;// Inst Mem size
   parameter ExceptionAddr = MEM_SIZE - 32'd120;//leaving last 30 inst addresses
	
	wire [31:0] PCOut, RegisterContent, RegisterNo;
	wire [31:0] Inst;
	 
	
// Instantiate the module
Mips_Pip_CPU uut (
    .clk(clk), 
    .RegisterContent(RegisterContent), 
    .RegisterNo(RegisterNo), 
    .PC(PCOut), 
    .Instruction(Inst), 
    .DataAddr(DataAddr), 
    .Data(Data),
	 .reset(reset)
    );
	 
	integer i, clk_cycle;
	reg [31:0] PC;
	
	reg [7:0] regfile[0:MEM_SIZE-1];
	assign Inst =  {regfile[PCOut],regfile[PCOut+1],regfile[PCOut+2],regfile[PCOut+3]};
	
	initial
	begin : clk_initialization
		clk=1;
		clk_cycle =0;
	end
	
	parameter T = 20;
	
	always 
	begin : clk_generator
		#(T/2) clk = ~clk;
	end
	
	always @(posedge clk)
	begin : to_print_clk_cycle_no
		clk_cycle = clk_cycle+1;
	//	$display("------------------------------Clk_Cycle = %d (- 2)------------------------------", clk_cycle);
	end
	
	initial 
	begin : main_block
	PC = 32'd0;
//	uut.s6.s0.regfile[0]=32'd1;
//--------------------------------------Load Inst. in Mem. at PC-------------------------------------------
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00000_00001_00000_100000;//r1=r0+r0;  //4
//	PC=PC+4;
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b100011_00000_00010_00000_00000_000000;//r2 = Memory[0]; //5
//	PC=PC+4;
//	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b000000_00000_00010_00100_00000_100000;//r4=r2+r0; //7
//	PC=PC+4;
	{regfile[PC],regfile[PC+1],regfile[PC+2],regfile[PC+3]} =32'b001000_00000_00101_00000_00000_000101;//r5=5+r0;  //8
	PC=PC+4;
	
   ///////////////////////////////////////////////////////////////////////////////////////////////
	//                        |     IF    |    ID    |    EX    |    MEM   |    WB					//
	//                        _----- _____----- _____----- _____----- _____-----_____				//
	//																															//
	//           nextPC_ready|PC    Inst|Inst  Ctrl|Ctrl  Rslt|Rslt M_W&R|M_W&R   WB|				//
	///////////////////////////////////////////////////////////////////////////////////////////////
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	initial
	begin : reset_block
		reset=1;
		#(2*T) reset=0;
	end
	
	initial
	begin : terminator
		integer i;
		//used by reset
		#(5*T);
		//Instr Execution
		for (i=1;i<=4;i=i+1)
		begin
			#(1*T);
			$stop;
			$display("uut.s2.s0.regfile[5] = %d", uut.s2.s0.regfile[5]);
		end
	end
endmodule

