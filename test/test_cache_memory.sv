`include "timescale.sv"

module test_cache_memory ();
  logic clk;
  logic rst;

  logic [dut.WaySize-1:0] way;
  logic [dut.SetSize-1:0] set;
  logic [dut.TagSize-1:0] tag;
  logic write_enable;
  logic [31:0] write_data;
  logic [31:0] read_data;
  logic [1:0] hits;
  logic [1:0] valid_flags;
  cache_memory #(
      .ADDR_SIZE (32),
      .NUM_SETS  (4),
      .NUM_WAYS  (2),
      .BLOCK_SIZE(32)
  ) dut (
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

  localparam int ClockCycle = 2;
  always #ClockCycle clk = !clk;

  logic [31:0] write_value;

  initial begin
    $dumpfile("cache.vcd");
    $dumpvars;
    clk = 0;
    rst = 1;
    #ClockCycle;
    rst = 0;

    way = 0;
    set = 0;
    tag = 27'($urandom);
    write_enable = 1;
    write_value = $urandom;
    write_data = write_value;
    #ClockCycle;
    write_enable = 0;
    tag += 1;
    assert (valid_flags == 'b00)
    else $error("Valid flags does not match");
    #1;
    tag -= 1;
    assert (valid_flags == 'b01)
    else $error("Valid flags does not match");
    $finish;
  end

endmodule
