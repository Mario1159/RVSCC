`include "timescale.sv"

module cache_controller #(
    parameter int ADDR_SIZE  = 32,
    parameter int NUM_SETS   = 16,
    parameter int NUM_WAYS   = 4,
    parameter int BLOCK_SIZE = 32
) (
    input logic clk,
    input logic [ADDR_SIZE - 1:0] addr,
    input logic write_enable,
    input logic replace_way,
    input logic [NUM_WAYS - 1:0] hits,
    input logic [NUM_WAYS - 1:0] valid_flags,
    output logic [SetSize - 1:0] set,
    output logic [TagSize - 1:0] tag,
    output logic [WaySize - 1:0] way,
    output logic hit,
    output logic cru_enable
);
  localparam int NumBlockBytes = BLOCK_SIZE / 4;
  localparam int ByteOffsetSize = $clog2(NumBlockBytes);
  localparam int SetSize = $clog2(NUM_SETS);
  localparam int TagSize = ADDR_SIZE - SetSize - ByteOffsetSize;
  localparam int WaySize = $clog2(NUM_WAYS);

  typedef struct packed {
    logic [ByteOffsetSize - 1:0] byte_offset;
    logic [SetSize - 1:0] set;
    logic [TagSize - 1:0] tag;
  } cache_addr_t;

  typedef enum logic [1:0] {
    READ = 'b00,
    WRITE_UNVALID = 'b10,
    REPLACE = 'b11
  } cache_state_t;

  cache_addr  packed_addr;
  cache_state_t state;

  logic [WaySize - 1:0] valid_encode, next_unvalid_way;
  PriorityEncoder #(
      .N(WaySize)
  ) valid_flags_encoder (
      .data_in(valid_flags),
      .data_out(valid_encode),
      .valid(valid_flags_encoder_valid)
  );
  PriorityEncoder #(
      .N(WaySize)
  ) read_way_encoder (
      .data_in(hits),
      .data_out(read_way),
      .valid(read_way_encoder_valid)
  );

  logic valid;
  always_comb begin
    packed_addr = cache_addr'(addr);
    set = packed_addr.set;
    tag = packed_addr.tag;

    hit = |hits;
    valid = &valid_flags;

    state = cache_state_t'{write_enable, valid};

    case (state)
      READ: begin
        cru_enable = 0;
        if (read_way_encoder_valid) way = read_way;
        else way = 'd0;
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

    if (valid_flags_encoder_valid) next_unvalid_way = valid_encode + 'd1;
    else next_unvalid_way = 'd0;
  end
endmodule
