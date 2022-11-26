`timescale 1ns / 1ps

module Extend 
#(
parameter N_IN = 12,
parameter N_OUT = 32
) (
input logic enable,
input logic[N_IN-1:0] imm,
output logic[N_OUT-1:0] imm_ext
    );
endmodule
