//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: alu
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////


module alu (input [3:0] opcode, 
		    input [31:0] A,B,
		    output carry, zero, 
		    output reg [31:0] Y,
		    output aluLessThan,
		    output aluUnsignedLT);
		    
		    reg adderCarryOut; 
		    localparam add = 4'b0000, sub = 4'b0001, sll = 4'b0010, bxor = 4'b0011, 
		    		   srl = 4'b0100, sra = 4'b0101, bor = 4'b0110, band = 4'b0111,
		    		   sltu = 4'b1000, beq = 4'b1001, bne = 4'b1010, lui = 4'b1011,
		    		   bge = 4'b1100, bltu = 4'b1101, bgeu = 4'b1110, blt = 4'b1111; 
		    
		    always @ (*) begin 
		    	case (opcode) 
		    		add: {adderCarryOut , Y} = A + B; 
		    		sub: Y = A - B;
		    		sll: Y = A << B; 
		    		bxor: Y = A ^ B;
		    		srl: Y = A >> B;
		    		sra: Y = $signed(A) >>> B; 
		    		bor: Y = A | B; 
		    		band: Y = A & B; 
		    		sltu: Y = (A < B) ? 1'b1: 1'b0; //unsigned
		    		
		    		//branching
		    		beq: Y = (A == B) ? 1'b1 : 1'b0; 
		    		bne: Y = (A != B) ? 1'b1 : 1'b0; 
		    		bge: Y = ((A[31] == 0) && (B[31] == 0) && (A[30:0] >= B [30:0])) ? 1'b1 :
		    								          ((A[31] == 0) && (B[31] == 1)) ? 1'b1 : 
		    								                                           1'b0 ;
		    								   
		    		bltu: Y = (A < B) ? 1'b1 : 1'b0; 
		    		bgeu: Y = (A >= B) ? 1'b1 : 1'b0; 
		    		blt: Y = ((A[31] == 0) && (B[31] == 0) && (A[30:0] < B [30:0])) ? 1'b1 :
		    				    				     ((A[31] == 1) && (B[31] == 0)) ? 1'b1 : 
		    				    				    								  1'b0 ;  
		    		
		    		//load upper immediate 
		    		lui: Y = {B, {12{1'b0}}};
		    		default: Y = 32'd0; 
		    	endcase			    	
		    end
		    
		    assign carry = (opcode == add && adderCarryOut == 1) ? 1'b1 :
		    						   //(opcode == beq && Y == 32'd1) ? 1'b1 : 
		    						   1'b0; 
		    						 
		    assign zero = (Y == 32'd0) ? 1'b1 : 1'b0; 
		    assign aluUnsignedLT = ((A[31] == 0) && (B[31] == 0) && (A[30:0] < B [30:0])) ? 1'b1 :
		    				    				     ((A[31] == 1) && (B[31] == 0)) ? 1'b1 : 
		    				    				    								  1'b0 ;          
            assign aluLessThan = (A < B); 
            
            always @(*) begin
    $display("[ALU] opcode=%b, A=%h, B=%h ? Y=%h", opcode, A, B, Y);
end
endmodule
