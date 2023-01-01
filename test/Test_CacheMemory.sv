`timescale 1ns / 1ps

module Test_CacheMemory();


logic[31:0] addr, write_data, read_data;
logic clk, rst, write_enable;

CacheMemory cache_memory(clk, rst, addr, write_enable, write_data, read_data);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    write_enable = 0;
    #25
    rst = 0;
    addr = 'd7;
    write_enable = 1;
    write_data = 'd10;
    #25
    write_enable = 0;
end

endmodule
