`timescale 1ns / 1ps

module Test_TwoWayLRUCache();
    logic clk, rst;
    logic[31:0] addr;
    logic write_enable;
    logic[31:0] write_data;
    logic[31:0] read_data;
    logic hit;
    
    TwoWayLRUCache #(
        .ADDR_SIZE(32),
        .NUM_SETS(16),
        .BLOCK_SIZE(32)
    ) cache (
        clk,
        rst,
        addr,
        write_enable,
        write_data,
        read_data,
        hit
    );
    
    always #1 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        write_enable = 0;
        #2;
        rst = 0;
        #2;
        write_enable = 1;
        for(int i = 0; i < 64; i++) begin
            addr = $urandom();
            write_data = $urandom();
            #2;
        end
    end
endmodule
