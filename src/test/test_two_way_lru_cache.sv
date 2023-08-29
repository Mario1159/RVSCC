`include "timescale.sv"

import rv32i_defs::*;

module test_two_way_lru_cache();

logic clk, rst;
data_memory_if mem_if(.clk(clk), .rst(rst));

two_way_lru_cache DUT(
    .data_mem_if(mem_if)
 );

localparam int ClockCycle = 2;
always #(ClockCycle/2) clk = !clk;

  localparam int MemoryWriteRange = 64;
  logic [MemoryWriteRange-1:0][OperandSize-1:0] write_values;
  int start_addr;

initial begin
    // Reset
    clk = 0;
    rst = 1;
    mem_if.write_enable = 0;
    #4;
    rst = 0;
    // Write to a range of values in memory
    mem_if.write_enable = 1;
    start_addr = $urandom;
    for (int i = 0; i < MemoryWriteRange; i++) begin
      mem_if.addr = 32'(start_addr + i * 4);
      write_values[i] = $urandom;
      mem_if.write_data = write_values[i];
      #2;
    end
        // Read and compare the same range of values
    mem_if.write_enable = 0;
    #4;
    for (int i = 0; i < MemoryWriteRange; i++) begin
      mem_if.addr = 32'(start_addr + i * 4);

      #2;
    end
    $finish;
end

endmodule
