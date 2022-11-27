`timescale 1ns / 1ps

// N = Bit width
module InstructionMemory #(
    parameter N = 32,
    parameter SIZE = 32
)
(
    input logic[N-1:0] addr,
    output logic[N-1:0] instr
);
    logic[N-1:0] mem [SIZE-1:0];

    initial $readmemh("../build/program.hex", mem);
endmodule
