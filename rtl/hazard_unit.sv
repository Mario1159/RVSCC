`timescale 1ns / 1ps

module HazardUnit (
    input logic rst,
    execute_pc_src,
    execute_result_src_0,
    memory_reg_write,
    writeback_reg_write,
    input logic [4:0] decode_rs_1,
    decode_rs_2,
    execute_rs_1,
    execute_rs_2,
    execute_rd,
    memory_rd,
    writeback_rd,
    output logic fetch_stall,
    decode_stall,
    decode_flush,
    execute_flush,
    output logic [1:0] execute_forward_a,
    execute_forward_b
);
  logic lw_stall;
  always_comb begin
    if (rst) begin
      fetch_stall = 0;
      decode_stall = 0;
      decode_flush = 1;
      execute_flush = 1;
      execute_forward_a = 0;
      execute_forward_b = 0;
    end else begin
      if (((execute_rs_1 == memory_rd) & memory_reg_write) & (execute_rs_1 != 0))
        execute_forward_a = 'b10;
      else if (((execute_rs_1 == writeback_rd) & writeback_reg_write) & (execute_rs_1 != 0))
        execute_forward_a = 'b01;
      else execute_forward_a = 'b00;

      if (((execute_rs_2 == memory_rd) & memory_reg_write) & (execute_rs_2 != 0))
        execute_forward_b = 'b10;
      else if (((execute_rs_2 == writeback_rd) & writeback_reg_write) & (execute_rs_2 != 0))
        execute_forward_b = 'b01;
      else execute_forward_b = 'b00;

      lw_stall = execute_result_src_0 & ((decode_rs_1 == execute_rd) | (decode_rs_2 == execute_rd));
      fetch_stall = lw_stall;
      decode_stall = lw_stall;

      decode_flush = execute_pc_src;
      execute_flush = lw_stall | execute_pc_src;
    end
  end
endmodule