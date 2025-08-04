//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: translate_mod
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////

module translate_mod(  
    input [31:0] instruction, 
    input [31:0] memdataOut,  // For loads
    input [31:0] rdReg2,         // For stores
    output reg [31:0] translate_out
);
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] opcode = instruction[6:0];
    
    always @(*) begin
        case (opcode)
            // Load instructions (I-type)
            7'b0000011: begin
                case (funct3)
                    3'b000: translate_out = {{24{memdataOut[7]}}, memdataOut[7:0]};  // lb
                    3'b001: translate_out = {{16{memdataOut[15]}}, memdataOut[15:0]}; // lh
                    3'b010: translate_out = memdataOut;                              // lw
                    3'b100: translate_out = {{24{1'b0}}, memdataOut[7:0]};           // lbu
                    3'b101: translate_out = {{16{1'b0}}, memdataOut[15:0]};          // lhu
                    default: translate_out = memdataOut;                             // Fallback
                endcase
            end
            
            // Store instructions 
            7'b0100011: begin
                case (funct3)
                    3'b000: translate_out = rdReg2[7:0];    // sb
                    3'b001: translate_out = rdReg2[15:0];   // sh 
                    3'b010: translate_out = rdReg2;         // sw 
                    default: translate_out = rdReg2;         // Fallback
                endcase
            end
            
            // Non-memory instructions
            default: translate_out = 32'h0;
        endcase
    end
    
    // Debugging
    always @(*) begin
        case (opcode)
            7'b0000011: $display("LOAD: funct3=%b, out=%h", funct3, translate_out);
            7'b0100011: $display("STORE: funct3=%b, data=%h", funct3, rdReg2);
            default:    ; // Silence non-memory ops
        endcase
    end
endmodule


