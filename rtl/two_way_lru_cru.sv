`include "timescale.sv"

module two_way_lru_cru #(
    parameter int ADDR_SIZE  = 32,
    parameter int NUM_SETS   = 16,
    parameter int BLOCK_SIZE = 32
) (
    input logic clk,
    input logic rst,
    input logic [ADDR_SIZE - 1:0] addr,
    input logic replace,
    output logic preferred
);
  localparam int NumBlocksBytes = BLOCK_SIZE / 4;
  localparam int ByteOffsetSize = $clog2(NumBlocksBytes);
  localparam int SetSize = $clog2(NUM_SETS);
  localparam int TagSize = ADDR_SIZE - SetSize - ByteOffsetSize;

  typedef struct packed {
    logic [ByteOffsetSize - 1:0] byte_offset;
    logic [SetSize - 1:0] set;
    logic [TagSize - 1:0] tag;
  } cache_addr_t;

  cache_addr_t packed_addr;
  assign packed_addr = cache_addr_t'(addr);

  logic [NUM_SETS - 1:0] lru;

  assign preferred = lru[packed_addr.set];
  always_ff @(posedge clk) begin
    if (rst) lru[packed_addr.set] <= 0;
    else if (replace) begin
      lru[packed_addr.set] <= !lru[packed_addr.set];
    end
  end
endmodule
