`timescale 1ns / 1ps

module ControlUnit
(
input logic[6:0] opcode,
input logic[2:0] funct_3,
input logic[6:0] funct_7,
input logic zero,
output logic pc_src,
output logic[1:0] result_src,
output logic mem_write,
output logic[2:0] alu_ctrl,
output logic alu_src,
output logic[1:0] imm_src,
output logic reg_write
);
endmodule
