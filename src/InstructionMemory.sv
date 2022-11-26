`timescale 1ns / 1ps

// N = Bit width
module InstructionMemory #(parameter N = 8)
(
    input logic[N-1:0] addr,
    output logic[N-1:0] instr
 );
endmodule
