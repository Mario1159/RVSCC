`timescale 1ns / 1ps

module ControlUnit
(
    input logic[6:0] opcode,
    input logic[2:0] funct_3,
    input logic[6:0] funct_7,
    input logic zero,
    output logic pc_src,
    output logic[1:0] result_src,
    output logic mem_write,
    output logic[2:0] alu_ctrl,
    output logic alu_src,
    output logic[1:0] imm_src,
    output logic reg_write
);
    logic branch, branch_result, branch_neg, jump;
    assign pc_src = (branch & branch_result) | jump;
    
    always_comb begin
        case(branch_neg)
            'd0: branch_result = !zero;
            'd1: branch_result = zero;
        endcase
    end
    
    logic[1:0] alu_op;
    MainDecoder main_decoder(
        opcode,
        branch,
        jump,
        result_src,
        mem_write,
        alu_src,
        imm_src,
        reg_write,
        alu_op
    );
    
    ALUDecoder alu_decoder(
        opcode[5],
        funct_3,
        funct_7[5],
        alu_op,
        alu_ctrl,
        branch_neg
    );
endmodule
