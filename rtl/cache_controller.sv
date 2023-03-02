`include "timescale.sv"

module cache_controller #(
    parameter int ADDR_SIZE  = 32,
    parameter int NUM_SETS   = 16,
    parameter int NUM_WAYS   = 4,
    parameter int BLOCK_SIZE = 32
) (
    input logic [ADDR_SIZE - 1:0] addr,
    input logic write_enable,
    input logic [$clog2(NUM_WAYS) - 1:0] replace_way,
    input logic [$clog2(NUM_WAYS) - 1:0] populate_way,
    output logic cru_enable,
    output logic [$clog2(NUM_WAYS) - 1:0] write_way,
    output logic [$clog2(NUM_SETS) - 1:0] set,
    output logic [ADDR_SIZE - $clog2(NUM_SETS) - $clog2(BLOCK_SIZE / 4) - 1:0] tag
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
    WRITE_POPULATE = 'b10,
    WRITE_REPLACE = 'b11
  } cache_state_t;

  cache_addr_t  packed_addr;
  cache_state_t state;

  logic [WaySize - 1:0]  next_populate_way;
 
  logic valid;
  always_comb begin
    packed_addr = cache_addr_t'(addr);
    set = packed_addr.set;
    tag = packed_addr.tag;

    state = cache_state_t'{write_enable, valid};
    case (state)
      READ: begin
        cru_enable = 0;
        write_way = 'dx;
      end
      WRITE_POPULATE: begin
        cru_enable = 0;
        write_way = next_populate_way;
      end
      WRITE_REPLACE: begin
        cru_enable = 1;
        write_way = replace_way;
      end
      default: begin
        cru_enable = 0;
        write_way = 'dx;
      end
    endcase
    next_populate_way = populate_way + 'd1;
  end
endmodule
