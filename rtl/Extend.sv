`timescale 1ns / 1ps

module Extend 
(
    input logic[1:0] imm_src,
    input logic[31:7] instr,
    output logic[31:0] imm_ext
);
    always_comb begin
        case(imm_src)
            'd0: imm_ext = {{20{instr[31]}}, instr[31:20]}; // Type I
            'd1: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // Type S
            'd2: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} ; // Type S
            default: imm_ext = 'dx;
        endcase
    end
endmodule
