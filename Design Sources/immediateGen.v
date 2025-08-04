//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: immediateGen
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////

module immediateGen(input [31:0] instruction, 
                     output reg [31:0] immediate); 
  parameter iType =  7'b0010011, lType = 7'b0000011, sType = 7'b0100011, sbType = 7'b1100011, uType = 7'b0110111, ujType = 7'b1101111; 
  
  always @ (instruction) begin 
    case (instruction[6:0])
      (iType | lType) : immediate = {{20{instruction[31]}}, instruction[31:20]}; 
      sType : begin immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      case (instruction[14:12])
    3'b000: $display("SB Immediate from immediategen (hex): %h", immediate); // Store Byte
    3'b001: $display("SH Immediate from immediategen (hex): %h", immediate); // Store Halfword
    3'b010: $display("SW Immediate from immediategen (hex): %h", immediate); // Store Word
    default: $display("Unknown Store Instruction funct3: %b", instruction[14:12]);
  endcase
    end
      sbType: immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
      uType: immediate = {instruction[31:12], {12{1'b0}}}; 
      ujType: immediate = {{20{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
      default: immediate = 32'd0; 
    endcase
  end
  
  always @(instruction) begin
    $display("Full instruction from immediategen: %h", instruction);
    $display("Bits [31:25] from immediategen: %b", instruction[31:25]);
    $display("Bits [11:7] from immediategen:  %b", instruction[11:7]);
end
endmodule 
