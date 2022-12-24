`timescale 1ns / 1ps
module Test_CPU();
    logic clk, reset;
    PipelinedCPU cpu(clk, reset);
    always #10 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        #100
        reset = 0;
    end
endmodule
