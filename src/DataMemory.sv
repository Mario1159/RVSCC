`timescale 1ns / 1ps

module DataMemory #(parameter N = 32)(
    input logic clk,
    input logic[N-1:0] addr,
    input logic enable_data,
    input logic[N-1:0] write_data,
    output logic[N-1:0] read_data
);
endmodule
