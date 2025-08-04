//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: register_file
// Email: charanya.k.rao@gmail.com
// Date Created: 07/01/2025
//////////////////////////////////////////////////////////////////////////////////

module register_file (input clk, rst_, wrtEn,
                 input [4:0] rdReg1, rdReg2, wrtReg, 
                 input [31:0] wrtData,
                 output [31:0] rdData1, rdData2);
                 
      wire wrt;
      reg [31:0] regfile [31:0];
                 
      assign rdData1 = (rdReg1 == 5'd0) ? 32'd0 : regfile[rdReg1];
      assign rdData2 = (rdReg2 == 5'd0) ? 32'd0 : regfile[rdReg2];
      assign wrt = wrtEn && (wrtReg != 0); 
      integer i; 
                 
        always @ (posedge clk or negedge rst_) begin 
           if(!rst_) 
              for (i = 0; i <= 31; i = i+1) begin
                regfile [i] <= 32'b0;
              end
           else if (wrt)
                regfile[wrtReg] <= wrtData; 
              end
              
endmodule
                      
