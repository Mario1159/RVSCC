`timescale 1ns / 1ps

module Test_RegisterFile();
    logic clk, rst;
    logic[31:0] addr_1, addr_2, addr_3;
    logic write_enable_3;
    logic[31:0] write_data_3;
    
    logic[31:0] read_data_1, read_data_2;
    
    RegisterFile register_file(
        clk,
        rst,
        addr_1,
        addr_2,
        addr_3,
        write_enable_3,
        write_data_3,
        read_data_1,
        read_data_2
        );
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        addr_1 = 0;
        addr_2 = 'd5;
        addr_3 = 0;
        write_enable_3 = 0;
        write_data_3 = 0;
        #5
        rst = 0;
        #5
        addr_3 = 'd5;
        write_data_3 = 'd14;
        write_enable_3 = 1;
    end
endmodule
