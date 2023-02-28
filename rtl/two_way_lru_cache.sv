`include "timescale.sv"

module two_way_lru_cache #(
    parameter int ADDR_SIZE  = 32,
    parameter int NUM_SETS   = 16,
    parameter int BLOCK_SIZE = 32
) (
    input logic clk,
    input logic rst,
    input logic [ADDR_SIZE - 1:0] addr,
    input logic write_enable,
    input logic [BLOCK_SIZE - 1:0] write_data,
    output logic [BLOCK_SIZE - 1:0] read_data,
    output logic hit
);
  localparam int NumWays = 2;
  localparam int NumBlockBytes = BLOCK_SIZE / 4;
  localparam int ByteOffsetSize = $clog2(NUM_BLOCK_BYTES);
  localparam int WaySize = $clog2(NUM_WAYS);
  localparam int SetSize = $clog2(NUM_SETS);
  localparam int TagSize = ADDR_SIZE - SET_SIZE - BYTE_OFFSET_SIZE;

  logic [NUM_WAYS - 1:0] valid_flags;
  logic [NUM_WAYS - 1:0] hits;

  logic [WAY_SIZE - 1:0] way;
  logic [SET_SIZE - 1:0] set;
  logic [TAG_SIZE - 1:0] tag;

  cache_memory #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .NUM_WAYS  (NumWays),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_memory (
      .clk(clk),
      .rst(rst),
      .way(way),
      .set(set),
      .tag(tag),
      .write_enable(write_enable),
      .write_data(write_data),
      .read_data(read_data),
      .hits(hits),
      .valid_flags(valid_flags)
  );

  two_way_lru_cru #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .BLOCK_SIZE
  ) cache_replace_unit (
      .clk(clk),
      .rst(rst),
      .addr(addr),
      .replace(cru_enable),
      .preferred(replace_preferred_way)
  );

  cache_controller #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .NUM_WAYS  (NUM_WAYS),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_controller (
      .clk(clk),
      .addr(addr),
      .write_enable(write_enable),
      .replace_way(replace_preferred_way),
      .hits(hits),
      .valid_flags(valid_flags),
      .set(set),
      .tag(tag),
      .way(way),
      .hit(hit),
      .cru_enable(cru_enable)
  );
endmodule
