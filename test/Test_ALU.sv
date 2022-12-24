`timescale 1ns / 1ps

module Test_ALU();
	logic[31:0] a, b;
	logic[2:0] opcode;
	logic[31:0] result;
	logic[3:0] status;
    ALU alu(a, b, opcode, result, status);
    
    initial begin
        a = 'd3;
        b = 'd11;
        opcode = 'd0;
    end
endmodule
