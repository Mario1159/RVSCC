`timescale 1ns / 1ps

module Test_DataMemory();
    logic clk;
    logic[31:0] addr;
    logic write_enable;
    logic[31:0] write_data;
    logic[31:0] read_data;
    
    DataMemory data_memory(
        clk,
        addr,
        write_enable,
        write_data,
        read_data
    );
    
    always #1 clk = ~clk;
    
    initial begin
        clk=0;
        addr='d11;
        #5
        write_enable=1;
        #5
        write_data=1;
        #5
        write_enable=0;
    end
endmodule
