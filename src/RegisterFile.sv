`timescale 1ns / 1ps

// N = Bit width
module RegisterFile #(
parameter N_REG_ADDR = 5,
parameter N_DATA = 32
) (
    input logic clk,
    input logic[N_REG_ADDR-1:0] addr_1, addr_2, addr_3,
    input logic write_enable_3,
    input logic[N_DATA-1:0] write_data_3,
    output logic[N_DATA-1:0] read_data_1, read_data_2
 );
endmodule
