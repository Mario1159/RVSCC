`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2022 06:24:42
// Design Name: 
// Module Name: DataMemory
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


module DataMemory #(parameter N = 32)(
    input logic clk,
    input logic[N-1:0] addr,
    input logic enable_data,
    input logic[N-1:0] write_data,
    output logic[N-1:0] read_data
);
endmodule
