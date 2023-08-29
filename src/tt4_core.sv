`include "timescale.sv"

module tt_um_mario1159_rv32core (
  input logic clk, rst
);
  instr_memory_if instr_mem_if ();
  instr_memory #(
      .FILE_PATH("../fw/test/test-core.mem")
  ) instr_mem (
      .instr_mem_if(instr_mem_if.mem)
  );

  data_memory_if data_mem_if (
      .clk(clk),
      .rst(rst)
  );

  data_memory #(.NUM_BLOCKS(128)) data_mem (.data_mem_if(data_mem_if.ram));

  single_cycle_datapath dut (
      .clk(clk),
      .rst(rst),
      .instr_mem_if(instr_mem_if.datapath),
      .data_mem_if(data_mem_if.datapath)
  );
endmodule