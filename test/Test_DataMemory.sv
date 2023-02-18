`timescale 1ns / 1ps

module Test_DataMemory ();
  logic clk, rst;
  logic [31:0] addr;
  logic write_enable;
  logic [31:0] write_data;
  logic [31:0] read_data;

  localparam int MemorySize = 16;
  DataMemory #(
      .SIZE(MemorySize)
  ) DUT (
      .clk(clk),
      .rst(rst),
      .addr(addr),
      .write_enable(write_enable),
      .write_data(write_data),
      .read_data(read_data)
  );

  always #1 clk = ~clk;

  localparam int MemoryWriteRange = 16;

  logic [MemoryWriteRange:0][31:0] write_values;
  int start_addr;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    // Reset
    clk = 0;
    rst = 1;
    write_enable = 0;
    #4;
    rst = 0;
    #1;
    // Write to a range of values in memory
    write_enable = 1;
    start_addr   = $urandom_range(15);
    for (int i = 0; i < MemoryWriteRange; i++) begin
      addr = start_addr + i;
      write_values[i] = $urandom();
      write_data = write_values[i];
      #2;
    end
    // Read and compare the same range of values
    write_enable = 0;
    #4;
    for (int i = 0; i < 16; i++) begin
      addr = start_addr + i;
      assert (read_data == write_values[i])
      else $error("Read failed at address %h", addr);
      #2;
    end
    $finish;
  end
endmodule
