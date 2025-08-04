`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Charanya Kaleshwara Rao 
// Design Name: RV32I
// Module Name: mainTestBench
//////////////////////////////////////////////////////////////////////////////////


module mainTestBench ();

    reg clk = 0;
    reg rst_;

    riscv_toplevel DUT (
        .clk(clk),
        .rst_(rst_)
    );

    always #5 clk = ~clk;

    initial begin
        // Reset the DUT
        rst_ = 0;
        #10;
        rst_ = 1;

        #2000;
		rst_ = 0; 
        //$finish;
   
    end
endmodule
