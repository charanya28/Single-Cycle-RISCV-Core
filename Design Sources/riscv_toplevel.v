//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao
// Design Name: RV32I
// Module Name: riscv_toplevel
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////
 

module riscv_toplevel(input clk, rst_); 

reg [31:0] pc;
wire [31:0] pc_next; 
wire [1:0] pc_sel;
wire is_branch; 
wire zero; //connect to zero output of ALU (1 bit) 
wire [31:0] pc_plus_four, jal_or_sb, rs1_plus_imm; //output wires of the 3 adders for feedback mux
wire branch; //connect to control_unit branch output
wire [31:0] immediate; //connect to immediateGen output pin 
wire branchCondition; 
wire [3:0] aluControl; //connect to aluControl output
wire aluLessThan; 
wire aluUnsignedLT; 
wire [31:0] rs1, rs2; //connect to readData1 and readData2 pins of reg_file 
wire jump; //connect to jump of control unit
wire [31:0] instruction; //connect to output of imem 
wire memRead; 
wire memWrite;
wire aluSrc; //wire connecting aluSrc from control unit to mux 
wire [31:0] aluin2; // output of mux deciding rs2 to alu
//wire rTypeInst; //check if rType Inst
//wire iTypeInst; //check if iType Inst
wire is_jal; //check if jal
wire is_jalr; //check if jalr
wire [31:0] WrtBackMux; //output of write back mux 
wire [31:0]Y;
wire [31:0]memdataOut;
wire regWrite;
wire carry;
wire [2:0]funct3 = instruction[14:12];
wire [6:0]funct7 = instruction [31:25];
wire [6:0]instOpcode = instruction[6:0];
wire [1:0]memToReg;
wire [1:0]aluOpcode;    
wire [4:0] rdReg1 = (!rst_) ? 5'd0 : instruction[19:15]; // rs1 if reset is not asserted
wire [4:0] rdReg2 = (!rst_) ? 5'd0 : instruction[24:20]; // rs2 if reset is not asserted
wire [4:0] wrtReg = instruction[11:7];  // rd
wire [31:0] translate_out;

//assign regWrite   = (!rst_) ? 1'b0 : cu.regWrite;
//assign memWrite   = (!rst_) ? 1'b0 : cu.memWrite;
//assign memRead    = (!rst_) ? 1'b0 : cu.memRead;

////////////////////////////////// program counter //////////////////////////////////

assign branchCondition = (aluControl == 4'b1001 && zero == 1'b1) ? 1'b1: //beq
						 (aluControl == 4'b1010 && zero == 1'b0) ? 1'b1: //bne
						 (aluControl == 4'b1111 && aluLessThan == 1'b1) ? 1'b1: //blt
						 (aluControl == 4'b1100 && aluLessThan == 1'b0) ? 1'b1: //bge
						 (aluControl == 4'b1101 && aluUnsignedLT == 1'b1) ? 1'b1: //bltu
						 (aluControl == 4'b1110 && aluUnsignedLT == 1'b0) ? 1'b1: //bgeu
						 										      		1'b0;
							

assign is_branch = (branchCondition & branch);

assign pc_plus_four = pc + 32'd4; //adder1
assign jal_or_sb = pc + immediate; //adder2
assign rs1_plus_imm = rs1 + immediate; //adder3

assign pc_sel = (jump && instruction[6:0] == 7'b1100111)? 2'b10: //jalr. instruction[6:0] is output of imem
				   			        (jump || is_branch) ? 2'b01: 
				   						                  2'b00;

assign pc_next = (pc_sel == 2'b00) ? pc_plus_four: 
				 (pc_sel == 2'b01) ? jal_or_sb:
				 (pc_sel == 2'b10) ? rs1_plus_imm:
				 							32'd0; 

always @ (posedge clk) begin
	if (!rst_) 
		pc <= 0;
	else 
		pc <= pc_next;  
end

////////////////////////////////// instruction memory //////////////////////////////////
imem imem1(.addr(pc), 
		   .instruction(instruction));
////////////////////////////////// register file //////////////////////////////////
register_file RF1 (.clk(clk), 
			  .rst_(rst_), 
			  .wrtEn(regWrite),
			  .rdReg1(rdReg1), 
			  .rdReg2(rdReg2), 
			  .wrtReg(wrtReg), 
              .wrtData(WrtBackMux),
              .rdData1(rs1), 
              .rdData2(rs2));
              
              
////////////////////////////////// Immediate Generator //////////////////////////////////
immediateGen IG1 (.instruction(instruction), 
                  .immediate(immediate)); 
                  
////////////////////////////////// Control Unit //////////////////////////////////
control_unit cu(.instruction(instruction), 
			 .aluSrc(aluSrc), 
			 .branch(branch), 
			 .jump(jump), 
			 .memRead(memRead), 
			 .memWrite(memWrite), 
			 .regWrite(regWrite), 
			 .memToReg(memToReg), 
			 .aluOp(aluOpcode));
			 
////////////////////////////////// ALU Controller //////////////////////////////////
aluController ac1(.aluOp(aluOpcode),
				  .funct7(funct7), //either 7 bit 0 or non-zero
				  .funct3(funct3), 
				  .instOpcode(instOpcode), 
				  .aluControl(aluControl));
				  
////////////////////////////////// ALU //////////////////////////////////

assign aluin2 = (aluSrc == 0) ? rs2: immediate;

alu alu1(.opcode(aluControl), 
	 .A(rs1),
	 .B(aluin2),
	 .carry(carry), 
	 .zero(zero), 
	 .Y(Y),
	 .aluLessThan(aluLessThan),
	 .aluUnsignedLT(aluUnsignedLT));
	 
	 
////////////////////////////////// Data Memory //////////////////////////////////

assign is_jal = (instruction[6:0] == 7'b1101111) ? 1'b1 : 1'b0;
assign is_jalr = (instruction[6:0] == 7'b1100111) ? 1'b1 : 1'b0; 	
		  																						   																								   																							  
assign WrtBackMux = (memToReg == 2'b00)? memdataOut: 
					(memToReg == 2'b01) ? Y: //alu result
					(memToReg == 2'b10) ? pc_plus_four: //jal or jalr
										  		32'd0;
										  			 
dataMem #(.addrWidth(32), .ramHeight(8192), .ramWidth(8)) dm1	(
				 												.addr(Y),
  		 		 												.clk(clk), 
  		 		 												.rst_(rst_), 
  		 		 												.memRead(memRead), 
  		 		 												.memWrite(memWrite),
  		 		 												.funct3(funct3),
                 												.dataIn(rs2), 
                 												.dataOut(memdataOut) 
                 												); 
                 												
translate_mod tm (  
                  .instruction(instruction),  
                  .memdataOut(memdataOut),
                  .rdReg2(rdReg2),
                  .translate_out(translate_out));
                                    												
            												
endmodule

