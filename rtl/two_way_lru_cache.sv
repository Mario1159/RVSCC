`include "timescale.sv"

module two_way_lru_cache #(
    parameter int ADDR_SIZE  = 32,
    parameter int NUM_SETS   = 16,
    parameter int BLOCK_SIZE = 32
) (
    data_memory_if.cache data_mem_if
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
      .clk(data_mem_if.clk),
      .rst(data_mem_if.rst),
      .write_way(write_way),
      .set(set),
      .tag(tag),
      .write_enable(data_mem_if.write_enable),
      .write_data(data_mem_if.write_data),
      .read_data(data_mem_if.read_data),
      .populate_way(populate_way),
      .populated(populated),
      .hit(data_mem_if.hit)
  );

  two_way_lru_cru #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_replace_unit (
      .clk(data_mem_if.clk),
      .rst(data_mem_if.rst),
      .addr(data_mem_if.addr),
      .replace(cru_enable),
      .preferred(replace_preferred_way)
  );

  cache_controller #(
      .ADDR_SIZE (ADDR_SIZE),
      .NUM_SETS  (NUM_SETS),
      .NUM_WAYS  (NumWays),
      .BLOCK_SIZE(BLOCK_SIZE)
  ) cache_controller (
      .addr(data_mem_if.addr),
      .write_enable(data_mem_if.write_enable),
      .replace_way(replace_preferred_way),
      .populate_way(populate_way),
      .populated(populated),
      .cru_enable(cru_enable),
      .write_way(write_way),
      .set(set),
      .tag(tag)
  );
endmodule
