`timescale 1ns / 1ps

module TwoWayLRUCRU #(
    parameter ADDR_SIZE = 32,
    parameter NUM_SETS = 16,
    parameter BLOCK_SIZE = 32
) (
    input logic clk, rst,
    input logic[ADDR_SIZE - 1:0] addr,
    input logic replace,
    output logic preferred
);
    localparam NUM_BLOCK_BYTES = BLOCK_SIZE / 4;
    localparam BYTE_OFFSET_SIZE = $clog2(NUM_BLOCK_BYTES);
    localparam SET_SIZE = $clog2(NUM_SETS);
    localparam TAG_SIZE = ADDR_SIZE - SET_SIZE - BYTE_OFFSET_SIZE;
    
    typedef struct packed {
        logic[BYTE_OFFSET_SIZE - 1:0] byte_offset;
        logic[SET_SIZE - 1:0] set;
        logic[TAG_SIZE - 1:0] tag;
    } cache_addr;
    
    cache_addr packed_addr;
    assign packed_addr = cache_addr'(addr);
    
    logic[NUM_SETS - 1:0] lru;
    
    assign preferred = lru[packed_addr.set];
    always_ff @(posedge clk) begin
        if (rst)
            lru[packed_addr.set] <= 0;
        else if (replace) begin
            lru[packed_addr.set] <= !lru[packed_addr.set];
        end
    end
endmodule
