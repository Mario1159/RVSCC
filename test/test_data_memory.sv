`timescale 1ns / 1ps

import rv32i_defs::*;

module test_data_memory ();
  localparam int NumInstr = 64;
  // Each block is a byte
  localparam int MemoryBlockSize = 8;
  // Each instruction address have 4 bytes
  localparam int NumMemoryBlocks = NumInstr * 4;
  localparam int AddrSize = $clog2(NumMemoryBlocks);

  logic clk, rst;
  data_memory_if #(
      .ADDR_SIZE(AddrSize),
      .DATA_SIZE(OperandSize)
  ) mem_if (
      .clk(clk),
      .rst(rst)
  );

  data_memory #(
      .BLOCK_SIZE(MemoryBlockSize),
      .NUM_BLOCKS(NumMemoryBlocks)
  ) dut (
      .mem_if(mem_if)
  );

  always #1 clk = ~clk;

  localparam int MemoryWriteRange = 16;
  logic [MemoryWriteRange-1:0][OperandSize-1:0] write_values;
  int start_addr;

  initial begin
    // Reset
    clk = 0;
    rst = 1;
    mem_if.write_enable = 0;
    #4;
    rst = 0;
    #1;
    // Write to a range of values in memory
    mem_if.write_enable = 1;
    start_addr = $urandom;
    for (int i = 0; i < MemoryWriteRange; i++) begin
      mem_if.addr = AddrSize'(start_addr + i * 4);
      write_values[i] = $urandom;
      mem_if.write_data = write_values[i];
      #2;
    end
    // Read and compare the same range of values
    mem_if.write_enable = 0;
    #4;
    for (int i = 0; i < MemoryWriteRange; i++) begin
      $display(start_addr, i, AddrSize);
      mem_if.addr = AddrSize'(start_addr + i * 4);
      #1;
      assert (mem_if.read_data == write_values[i])
      else $error("Read failed at address %h", mem_if.addr);
      #1;
    end
    $finish;
  end
endmodule
