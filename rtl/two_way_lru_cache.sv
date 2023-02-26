`timescale 1ns / 1ps

module TwoWayLRUCache #(
    parameter ADDR_SIZE = 32,
    parameter NUM_SETS = 16,
    parameter BLOCK_SIZE = 32
)(
    input logic clk, rst,
    input logic[ADDR_SIZE - 1:0] addr,
    input logic write_enable,
    input logic[BLOCK_SIZE - 1:0] write_data,
    output logic[BLOCK_SIZE - 1:0] read_data,
    output logic hit
);
    localparam NUM_WAYS = 2;
    localparam NUM_BLOCK_BYTES = BLOCK_SIZE / 4;
    localparam BYTE_OFFSET_SIZE = $clog2(NUM_BLOCK_BYTES);
    localparam WAY_SIZE = $clog2(NUM_WAYS);
    localparam SET_SIZE = $clog2(NUM_SETS);
    localparam TAG_SIZE = ADDR_SIZE - SET_SIZE - BYTE_OFFSET_SIZE;
    
    logic[NUM_WAYS - 1:0] valid_flags;
    logic[NUM_WAYS - 1:0] hits;
    
    logic[WAY_SIZE - 1:0] way;
    logic[SET_SIZE - 1:0] set;
    logic[TAG_SIZE - 1:0] tag;
    
    CacheMemory #(
        ADDR_SIZE,
        NUM_SETS,
        NUM_WAYS,
        BLOCK_SIZE
    ) cache_memory(
        clk,
        rst,
        way,
        set,
        tag,
        write_enable,
        write_data,
        read_data,
        hits,
        valid_flags
    );
    
    TwoWayLRUCRU #(
        ADDR_SIZE,
        NUM_SETS,
        BLOCK_SIZE
    ) cache_replace_unit(
        clk,
        rst,
        addr,
        cru_enable,
        replace_preferred_way
    );
    
    CacheController #(
        ADDR_SIZE,
        NUM_SETS,
        NUM_WAYS,
        BLOCK_SIZE
    ) cache_controller (
        clk,
        addr,
        write_enable,
        replace_preferred_way,
        hits,
        valid_flags,
        set,
        tag,
        way,
        hit,
        cru_enable
    );
endmodule
