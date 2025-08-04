//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: aluController
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////

module aluController(input [1:0] aluOp,
					 input [6:0] funct7, //either 7 bit 0 or non-zero
					 input [2:0] funct3, 
					 input [6:0] instOpcode, 
					 output reg [3:0] aluControl);
	
					 localparam memoryInst = 2'b00, bitwiseOrShift = 2'b01, 
					 			branch = 2'b10, upperImmediate = 2'b11; 
					 /* aluControl output operation cases: 
					 add = 4'b0000	sub = 4'b0001		sll = 4'b0010		bxor = 4'b0011  
					 srl = 4'b0100	sra = 4'b0101		bor = 4'b0110		band = 4'b0111
					 sltu = 4'b1000  beq = 4'b1001		bne = 4'b1010		lui = 4'b1011
					 bge = 4'b1100	bltu = 4'b1101		bgeu = 4'b1110		blt = 4'b1111
					  */
	reg srai;
	reg sraOrSub;
				  
				always @ (*) begin 
		
					 srai = ((funct7 == 7'b0100000) && (funct3 == 3'b101) && (instOpcode == 7'b0010011)) ? 1'b1 : 1'b0;
					 sraOrSub = ((funct7 == 7'b0100000)  && (instOpcode == 7'b0110011)) ? 1'b1: 1'b0; 

					 
					  case (aluOp)
					  	memoryInst: aluControl = 4'b0000; 
					  	
					  	bitwiseOrShift: begin 
					  			if (sraOrSub)
					  				aluControl = (funct3 == 3'b101)? 4'b0101 : 4'b0001; //sra or sub
					  			else if (srai)
					  				aluControl = 4'b0101; //srai
					  				
					  				else begin 
					  					case(funct3)
					  						3'b000: aluControl = 4'b0000; //add
					  						3'b001: aluControl = 4'b0010; //sll
					  						3'b100: aluControl = 4'b0011; //bxor
					  						3'b101: aluControl = 4'b0100; //srl
					  						3'b110: aluControl = 4'b0110; //bor
					  						3'b111: aluControl = 4'b0111; //band
					  						default: aluControl = 4'b0000; 
					  					endcase
					  				end
					  	end
					  	
					  	branch: begin 
					  		case(funct3) 
					  			3'b000: aluControl = 4'b1001; //beq
					  			3'b001: aluControl = 4'b1010; //bne
					  			3'b100: aluControl = 4'b1111; //blt
					  			3'b101: aluControl = 4'b1100; //bge
					  			3'b110: aluControl = 4'b1101; //bltu
					  			3'b111: aluControl = 4'b1110;//bgeu
					  			default: aluControl = 4'b0000;
					  	endcase
					  	end
					  	
					  	upperImmediate: 
					  			aluControl = 4'b1011; //lui
					  			
					  	default: aluControl = 4'b0000;
					  endcase
				end
endmodule
