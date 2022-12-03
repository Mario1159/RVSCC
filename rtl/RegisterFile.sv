`timescale 1ns / 1ps

// N = Bit width
module RegisterFile #(
parameter N_REG_ADDR = 5,
parameter N_REG = 32,
parameter N_DATA = 32
) (
    input logic clk,
    input logic[N_REG_ADDR-1:0] addr_1, addr_2, addr_3,
    input logic write_enable_3,
    input logic[N_DATA-1:0] write_data_3,
    output logic[N_DATA-1:0] read_data_1, read_data_2
 );
    logic[N_REG:0] mem;
 
    always_ff @(posedge clk) begin
        if (write_enable_3)
            mem[addr_3] <= write_data_3;
        else begin
            read_data_1 <= mem[addr_1];
            read_data_2 <= mem[addr_2];
        end
    end
endmodule
