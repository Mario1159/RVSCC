`timescale 1ns / 1ps
module Test_CPU();
    logic clk, reset;
    CPU cpu(clk, reset);
    always #1 clk = ~clk;
    initial begin
        reset = 1;
        #5
        reset = 0;
    end
endmodule
