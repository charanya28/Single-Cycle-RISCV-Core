//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: control_unit
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////


module control_unit(input [31:0] instruction, 
					output reg aluSrc, branch, jump, memRead, memWrite, regWrite, 
					output reg [1:0] memToReg, aluOp);
					
					localparam iType = 7'b0010011, lType = 7'b0000011, 
							   rType = 7'b0110011, sType = 7'b0100011, 
							   sbType = 7'b1100011, uType = 7'b0110111, 
							   ujType = 7'b1101111; 
							   
							   always @ (instruction) begin 
							   case (instruction[6:0])  
							   
							   iType: begin
							   		aluSrc = 1'b1;
							   		branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b1; 
							   		memToReg = 2'b01; 
							   		aluOp = 2'b01; 
							   		 
							   end 
							   
							   lType: begin
							   		aluSrc = 1'b1;
							   		branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b1;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b1; 
							   		memToReg = 2'b00; 
							   		aluOp = 2'b00; 
							   end 
							   
							   rType: begin
							   		aluSrc = 1'b0;
							   		branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b1; 
							   		memToReg = 2'b01; 
							   		aluOp = 2'b01; 
							  end 
							  
							   	sType: begin
							   	     aluSrc = 1'b1; 
							   		//aluSrc = 1'b1;
									branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b1; 
							   		regWrite = 1'b0; 
							   		memToReg = 2'b00; 
							   		aluOp = 2'b00; 
							   end 
							   
							   sbType: begin
							   		aluSrc = 1'b0;
							   		branch = 1'b1; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b0; 
							   		memToReg = 2'bxx; 
							   		aluOp = 2'b10; 
							   end 		
							   					   							   						   
							   uType: begin
							   		aluSrc = 1'b1;
							   		branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b1; 
							   		memToReg = 2'b00; 
							   		aluOp = 2'b11; 
							  end 
							  
							   	ujType: begin
							   		aluSrc = 1'b1;
							   		branch = 1'b0; 
							   		jump = 1'b1; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b1; 
							   		memToReg = 2'b10; 
							   		aluOp = 2'bxx; 
							   	end 		
							   	
							   	default: begin
							   		aluSrc = 1'b1;
							   		branch = 1'b0; 
							   		jump = 1'b0; 
							   		memRead = 1'b0;
							   		memWrite = 1'b0; 
							   		regWrite = 1'b0; 
							   		memToReg = 2'b00; 
							   		aluOp = 2'b00;
							   	end				   							   							   							   
							   endcase
							   
							   
							   end
			
			
endmodule
