`timescale 1ns / 1ps

module CacheController #(
    parameter ADDR_SIZE = 32,
    parameter NUM_SETS = 16,
    parameter NUM_WAYS = 4,
    parameter BLOCK_SIZE = 32
) (
    input logic clk,
    input logic[ADDR_SIZE - 1:0] addr,
    input logic write_enable,
    input logic replace_way,
    input logic[NUM_WAYS - 1:0] hits,
    input logic[NUM_WAYS - 1:0] valid_flags,
    output logic[SET_SIZE - 1:0] set,
    output logic[TAG_SIZE - 1:0] tag,
    output logic[WAY_SIZE - 1:0] way,
    output logic hit,
    output logic cru_enable
);
    localparam NUM_BLOCK_BYTES = BLOCK_SIZE / 4;
    localparam BYTE_OFFSET_SIZE = $clog2(NUM_BLOCK_BYTES);
    localparam SET_SIZE = $clog2(NUM_SETS);
    localparam TAG_SIZE = ADDR_SIZE - SET_SIZE - BYTE_OFFSET_SIZE;
    localparam WAY_SIZE = $clog2(NUM_WAYS);
    
    typedef struct packed {
        logic[BYTE_OFFSET_SIZE - 1:0] byte_offset;
        logic[SET_SIZE - 1:0] set;
        logic[TAG_SIZE - 1:0] tag;
    } cache_addr;
    
    typedef enum logic[1:0] {
        READ = 'b00,
        WRITE_UNVALID = 'b10,
        REPLACE = 'b11
    } cache_state;
    
    cache_addr packed_addr;
    cache_state state;
    
    logic[WAY_SIZE - 1:0] valid_encode, next_unvalid_way;
    PriorityEncoder #(.N(WAY_SIZE)) valid_flags_encoder(valid_flags, valid_encode, valid_flags_encoder_valid);
    PriorityEncoder #(.N(WAY_SIZE)) read_way_encoder(hits, read_way, read_way_encoder_valid);

    logic valid;
    always_comb begin
        packed_addr = cache_addr'(addr);
        set = packed_addr.set;
        tag = packed_addr.tag;
        
        hit = |hits;
        valid = &valid_flags;

        state = cache_state'{write_enable, valid};

        case(state)
            READ: begin
                cru_enable = 0;
                if (read_way_encoder_valid)
                    way = read_way;
                else
                    way = 'd0;
            end
            WRITE_UNVALID: begin
                cru_enable = 0;
                way = next_unvalid_way;
            end
            REPLACE: begin
                cru_enable = 1;
                way = replace_way;
            end
            default: begin
                cru_enable = 0;
                way = 'dx;
            end
        endcase
        
        if (valid_flags_encoder_valid)
            next_unvalid_way = valid_encode + 'd1;
        else
            next_unvalid_way = 'd0;
    end
    /*
    always_ff @(posedge clk) begin

    end*/
endmodule
