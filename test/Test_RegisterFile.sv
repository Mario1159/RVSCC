`timescale 1ns / 1ps

module Test_RegisterFile();
    logic clk;
    logic[31:0] addr_1, addr_2, addr_3;
    logic write_enable_3;
    logic[31:0] write_data_3;
    
    logic[31:0] read_data_1, read_data_2;
    
    RegisterFile register_file(
        clk,
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
        write_enable_3 = 1;
        addr_3 = 'd10;
        write_data_3 = 'd21;
        #5
        write_enable_3 = 0;
        addr_1 = 'd10;
    end
endmodule
