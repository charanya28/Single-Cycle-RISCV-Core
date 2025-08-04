//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: imem
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////


module imem(input[31:0]addr, 
			output [31:0] instruction);
			
			reg [7:0] memory [127:0];
			
			integer i; 		
initial begin 
	for (i = 0; i < 128; i = i + 1) 
			memory [i] = 8'd0; 
    //////////////////////////////////////////////////
    // 1. Initialize Registers
    //////////////////////////////////////////////////
    
    memory[0]  = 8'b00000000;
    memory[1]  = 8'b00000000;
    memory[2]  = 8'b00000000;
    memory[3]  = 8'b00000000; 
    
    // ADDI x1, x0, 5       (x1 = 5)
     memory[4]  = 8'b10010011;
    memory[5]  = 8'b00000000;
    memory[6]  = 8'b01010000;
    memory[7]  = 8'b00000000; 

    // ADDI x7, x0, 1       (x6 = 1)
    memory[8]  = 8'b10010011;
    memory[9]  = 8'b00000011;
    memory[10]  = 8'b00010000;
    memory[11]  = 8'b00000000; 

    
	//				SW X07, 23(X06)
	memory[12]  = 8'b10100011;
	memory[13]  = 8'b00101011;
	memory[14]  = 8'b01110011;
	memory[15]  = 8'b00000000;

	 //				ADDI X08, X08, 1223
	memory[16] = 8'b00010011;
	memory[17] = 8'b00000100;
	memory[18] = 8'b01110100;
	memory[19] = 8'b01001100;

	//				LW X09, 0(X08)
	memory[20] = 8'b10000011;
	memory[21] = 8'b00100100;
	memory[22] = 8'b00000100;
	memory[23] = 8'b00000000;

	//				SUB X09, X09, X00
	memory[24] = 8'b10110011;
	memory[25] = 8'b10000100;
	memory[26] = 8'b00000100;
	memory[27] = 8'b00000000; 
	
	// SB x08, 23(x07)
	memory[28] = 8'b10100011;
	memory[29] = 8'b10001011; 
	memory[30] = 8'b10000011; 
	memory[31] = 8'b00000000; 
	
end 

assign instruction = {memory[addr + 3],memory[addr + 2],memory[addr + 1],memory[addr]}; 

always @ (*) begin 
$display("Full instruction from imem: %h", instruction);
$display("imm[31:25] from imem: %b, imm[11:7]: %b", instruction[31:25], instruction[11:7]);

end			
endmodule
