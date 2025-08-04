//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: dataMem
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////

module dataMem #(parameter addrWidth = 32, ramHeight = 8192, ramWidth = 8) 
  				(input [addrWidth - 1: 0] addr,
  		 		input clk, rst_, memRead, memWrite,
  		 		input [2:0] funct3,
                input [31:0] dataIn, 
                output [31:0] dataOut ); 
  
  reg [ramWidth - 1: 0] memory [ramHeight - 1: 0];
  integer i;
  
  assign dataOut = memRead ? {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]} : 32'd0; 
  
  always @ (posedge clk or negedge rst_ ) begin 
    if(!rst_) begin
      for (i = 0; i < ramHeight; i = i + 1)
        memory[i] <= 8'd0; 
    end   
    else if (memWrite) begin 
    case(funct3) //sb
           3'b000: begin
            memory[addr] <= dataIn[7:0];
    end
           3'b001: begin //sh
            memory[addr] <= dataIn[7:0];
            memory[addr + 1] <= dataIn[15:8];
    end
           3'b010: begin //sw
            memory[addr] <= dataIn[7:0];
            memory[addr + 1] <= dataIn[15:8];
            memory[addr + 2] <= dataIn[23:16];
            memory[addr + 3] <= dataIn[31:24];
    end
    endcase
    end    
  end
  
endmodule 
