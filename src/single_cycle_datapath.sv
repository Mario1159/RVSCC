`include "timescale.sv"

import rv32i_defs::*;

module tt_um_single_cycle_datapath (
    input logic clk,
    input logic rst,
    input logic[31:0] instr,
    output logic[31:0] addr,
    output logic[31:0] alu_result,
    input logic[31:0] read_data,
    output logic write_enable,
);
  logic [InstructionSize-1:0] pc, pc_next;
  logic [OperandSize-1:0] imm_ext;
  logic [InstructionSize-1:0] pc_target;
  assign pc_target = imm_ext + pc;

  logic pc_src;
  always_comb begin
    case (pc_src)
      'd0: pc_next = pc + 'd4;
      'd1: pc_next = pc_target;
      default: pc_next = 'dx;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) pc <= 'b0;
    else pc <= pc_next;
  end

  assign addr = pc;

  logic reg_write;
  logic [OperandSize-1:0] read_data_1, read_data_2;
  logic [OperandSize-1:0] result;
  register_file register_file (
      .clk(clk),
      .rst(rst),
      .addr_1(instr[19:15]),
      .addr_2(instr[24:20]),
      .addr_3(instr[11:7]),
      .write_enable_3(reg_write),
      .write_data_3(result),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2)
  );

  logic [1:0] result_src;
  logic [1:0] imm_src;
  logic [2:0] alu_ctrl;
  logic alu_src;
  logic alu_status_zero;
  logic jump;
  logic branch;
  logic branch_alu_neg;
  control_unit control_unit (
      .opcode(instr[6:0]),
      .funct_3(instr[14:12]),
      .funct_7(instr[31:25]),
      .result_src(result_src),
      .mem_write(write_enable),
      .alu_ctrl(alu_ctrl),
      .alu_src(alu_src),
      .imm_src(imm_src),
      .reg_write(reg_write),
      .jump(jump),
      .branch(branch),
      .branch_alu_neg(branch_alu_neg)
  );

  jump_control jump_control (
      .jump(jump),
      .branch(branch),
      .branch_alu_neg(branch_alu_neg),
      .zero(alu_status_zero),
      .pc_src(pc_src)
  );

  imm_extend imm_extend (
      .imm_src(imm_src[1:0]),
      .instr  (instr[31:7]),
      .imm_ext(imm_ext[31:0])
  );

  logic [OperandSize-1:0] src_b;
  always_comb begin
    case (alu_src)
      'd0: src_b = read_data_2;
      'd1: src_b = imm_ext;
      default: src_b = 'dx;
    endcase
  end

  logic [3:0] alu_status;
  assign alu_status_zero = alu_status[2];
  alu alu (
      .a(read_data_1),
      .b(src_b),
      .operation(alu_opcode_t'(alu_ctrl)),
      .result(alu_result),
      .status(alu_status)
  );

  always_comb begin
    case (result_src)
      'b00: result = alu_result;
      'b01: result = read_data;
      'b10: result = pc + 'd4;
      'b11: result = 'dx;
      default: result = 'dx;
    endcase
  end
endmodule
