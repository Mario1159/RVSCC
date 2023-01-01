`timescale 1ns / 1ps

module CacheMemory #(
    parameter ADDR_SIZE = 32,
    parameter NUM_SETS = 16,
    parameter NUM_WAYS = 4,
    parameter BLOCK_SIZE = 32
)(
    input logic clk, rst,
    input logic[WAY_SIZE - 1:0] way,
    input logic[SET_SIZE - 1:0] set,
    input logic[TAG_SIZE - 1:0] tag,
    input logic write_enable,
    input logic[BLOCK_SIZE - 1:0] write_data,
    output logic[BLOCK_SIZE - 1:0] read_data,
    output logic[NUM_WAYS - 1:0] hits,
    output logic[NUM_WAYS - 1:0] valid_flags
);
    localparam NUM_BLOCK_BYTES = BLOCK_SIZE / 4;
    localparam BYTE_OFFSET_SIZE = $clog2(NUM_BLOCK_BYTES);
    localparam WAY_SIZE = $clog2(NUM_WAYS);
    localparam SET_SIZE = $clog2(NUM_SETS);
    localparam TAG_SIZE = ADDR_SIZE - SET_SIZE - BYTE_OFFSET_SIZE;
   
    typedef struct packed {
        logic[BLOCK_SIZE - 1:0] data;
        logic[TAG_SIZE - 1:0] tag;
        logic valid;
    } cache_line;
    
    typedef cache_line[NUM_SETS - 1:0] cache_way;
    cache_way[NUM_WAYS - 1:0] ways;
    
    assign read_data = ways[way][set].data;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            // Reset valid flags
            for (int i = 0; i < NUM_WAYS; i++) begin
                for (int j = 0; j < NUM_SETS; j++) begin
                    ways[i][j].data <= 'dx;
                    ways[i][j].tag <= 'dx;
                    ways[i][j].valid <= 0;
                end
            end
        end else if (write_enable) begin
            ways[way][set].data <= write_data;
            ways[way][set].tag <= tag;
            ways[way][set].valid <= 1;
       end
    end
    always_comb begin
        for (int i = 0; i < NUM_WAYS; i++) begin
            valid_flags[i] = ways[i][set].valid;
            hits[i] = ways[i][set].valid && (tag == ways[i][set].tag);
        end
    end
endmodule