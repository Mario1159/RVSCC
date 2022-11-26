`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2022 04:31:59
// Design Name: 
// Module Name: ControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
