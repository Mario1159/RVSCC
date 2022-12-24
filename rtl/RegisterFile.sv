`timescale 1ns / 1ps

// N = Bit width
module RegisterFile #(
parameter N_REG_ADDR = 5,
parameter N_REG = 32,
parameter N_DATA = 32
) (
    input logic clk, rst,
    input logic[N_REG_ADDR-1:0] addr_1, addr_2, addr_3,
    input logic write_enable_3,
    input logic[N_DATA-1:0] write_data_3,
    output logic[N_DATA-1:0] read_data_1, read_data_2
 );
    logic[N_DATA-1:0] mem[N_REG-1:1];
    logic[N_DATA-1:0] zero;
 
    always_comb begin
        zero = 'd0;
        if (addr_1 == 'd0)
            read_data_1 = zero;
        else
            read_data_1 = mem[addr_1];
        if (addr_2 == 'd0)
            read_data_2 = zero;
        else
            read_data_2 = mem[addr_2];
    end
 
    always_ff @(posedge clk) begin
        if (rst) begin
            mem <= '{default: '0};
            mem[2] <= 'd255;
        end
        else if (write_enable_3) begin
            mem[addr_3] <= write_data_3;
        end
    end
endmodule
