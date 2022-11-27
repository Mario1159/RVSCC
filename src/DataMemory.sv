`timescale 1ns / 1ps

module DataMemory #(
parameter N = 32,
parameter SIZE = 64)(
    input logic clk,
    input logic[N-1:0] addr,
    input logic write_enable,
    input logic[N-1:0] write_data,
    output logic[N-1:0] read_data
);
    logic[N-1:0] mem[SIZE-1];
    
    always_ff @(posedge clk) begin
        if (write_enable)
            mem[addr] <= write_data;
        else
            read_data <= mem[addr];
    end
endmodule
