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
  localparam int ByteOffsetSize = $clog2(NumBlockBytes);
  localparam int WaySize = $clog2(NumWays);
  localparam int SetSize = $clog2(NUM_SETS);
  localparam int TagSize = ADDR_SIZE - SetSize - ByteOffsetSize;

  logic [$clog2(NumWays) - 1:0] populate_way;
  logic read_valid;

  logic [WaySize - 1:0] way;
  logic [SetSize - 1:0] set;
  logic [TagSize - 1:0] tag;

  cache_memory #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .NUM_WAYS  (NumWays),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_memory (
      .clk(clk),
      .rst(rst),
      .write_way(write_way),
      .set(set),
      .tag(tag),
      .write_enable(write_enable),
      .write_data(write_data),
      .read_data(read_data),
      .populate_way(populate_way),
      .hit(hit)
  );

  two_way_lru_cru #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .BLOCK_SIZE(BLOCK_SIZE)
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
      .NUM_WAYS  (NumWays),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_controller (
      .addr(addr),
      .write_enable(write_enable),
      .replace_way(replace_preferred_way),
      .populate_way(populate_way),
      .cru_enable(cru_enable),
      .write_way(write_way),
      .set(set),
      .tag(tag)
  );
endmodule
