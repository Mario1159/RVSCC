`timescale 1ns / 1ps

module test_single_cycle_core ();
  logic clk, rst;
  always #1 clk = ~clk;

  instr_memory_if instr_mem_if;
  instr_memory #(.FILE_PATH("../fw/test/test-core.mem")) instr_mem (instr_mem_if.mem);

  data_memory_if data_mem_if (
      .clk(clk),
      .rst(rst)
  );
  data_memory data_mem (.data_mem_if(data_mem_if.ram));

  single_cycle_datapath dut (
      .clk(clk),
      .rst(rst),
      .instr_mem_if(instr_mem_if.datapath),
      .data_mem_if(data_mem_if.datapath)
  );

  initial begin
    $dumpfile("single_cycle.vcd");
    $dumpvars(1, dut);
    clk = 0;
    rst = 1;
    #4;
    rst = 0;
    #100;
    $finish;
  end
endmodule
