`timescale 1ns / 1ps

module JumpControl (
    input  logic jump,
    branch,
    branch_alu_neg,
    zero,
    output logic pc_src
);
  logic alu_result, branch_result;
  assign alu_result = !zero;

  always_comb begin
    case (branch_alu_neg)
      'd0: branch_result = alu_result;
      'd1: branch_result = !alu_result;
      default: branch_result = 'dx;
    endcase
  end

  assign pc_src = (branch & branch_result) | jump;
endmodule
