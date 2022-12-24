`timescale 1ns / 1ps

module ALUDecoder(
    input logic opcode_5,
    input logic[2:0] funct_3,
    input logic funct_7_5,
    input logic[1:0] alu_op,
    output logic[2:0] alu_ctrl,
    output logic branch_neg
);
    always_comb begin
        casex({alu_op, funct_3, opcode_5, funct_7_5})
            'b00xxxxx: alu_ctrl = 'b000; // lw sw
            'b01000xx: begin
                alu_ctrl = 'b001; // beq
                branch_neg = 1;
            end
            'b01100xx: begin
                alu_ctrl = 'b101; // blt
                branch_neg = 0;
            end
            'b01101xx: begin
                alu_ctrl = 'b101; // bge
                branch_neg = 1;
            end
            'b1000000: alu_ctrl = 'b000; // add
            'b1000001: alu_ctrl = 'b000; // add
            'b1000010: alu_ctrl = 'b000; // add
            'b1000011: alu_ctrl = 'b001; // sub
            'b10010xx: alu_ctrl = 'b101; // slt
            'b10110xx: alu_ctrl = 'b000; // or
            'b10111xx: alu_ctrl = 'b000; // and
            default: alu_ctrl = 'bxxx;
        endcase
    end
endmodule
