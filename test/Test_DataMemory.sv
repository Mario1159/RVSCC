`timescale 1ns / 1ps

module Test_DataMemory();
    logic clk, rst;
    logic[31:0] addr;
    logic write_enable;
    logic[31:0] write_data;
    logic[31:0] read_data;
    
    DataMemory #(
        .SIZE(16)
    ) data_memory(
        clk,
        rst,
        addr,
        write_enable,
        write_data,
        read_data
    );
    
    always #1 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        write_enable = 0;
        #4;
        rst = 0;
        #1;
        write_enable = 1;
        for(int i = 0; i < 16; i++) begin
            addr = $urandom_range(15);
            write_data = $urandom();
            #2;
        end
    end
endmodule
