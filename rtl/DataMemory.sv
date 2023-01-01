`timescale 1ns / 1ps

module DataMemory #(
parameter N = 32,
parameter SIZE = 32,
parameter BYTE_WIDTH = 8)(
    input logic clk, rst,
    input logic[N-1:0] addr,
    input logic write_enable,
    input logic[N-1:0] write_data,
    output logic[N-1:0] read_data
);
    logic[BYTE_WIDTH-1:0] mem[SIZE*BYTE_WIDTH-1:0];

    assign read_data = {mem[addr + 'd0],
                        mem[addr + 'd1],
                        mem[addr + 'd2],
                        mem[addr + 'd3]};
    always_ff @(posedge clk) begin
        if (rst)
            mem = '{default: '0};
        else if (write_enable)
            {mem[addr + 'd0],
             mem[addr + 'd1],
             mem[addr + 'd2],
             mem[addr + 'd3]} <= write_data;
    end
endmodule