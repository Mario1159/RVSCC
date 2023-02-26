`timescale 1ns / 1ps

module test_single_cycle_core ();
  logic clk, rst;
  always #1 clk = ~clk;

  single_cycle_datapath dut (
      .clk(clk),
      .rst(rst),
      .mem_if(mem_if.datapath)
  );

  data_memory_if mem_if (
      .clk(clk),
      .rst(rst)
  );

  data_memory mem (.mem_if(mem_if.ram));

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
