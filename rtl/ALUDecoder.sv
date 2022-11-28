`timescale 1ns / 1ps

module ALUDecoder(
    input logic opcode_5,
    input logic[2:0] funct_3,
    input logic[6:0] funct_7,
    input logic[1:0] alu_op,
    output logic[2:0] alu_ctrl
);
    always_comb begin
        case({alu_op, funct_3, opcode_5, funct_7})
            'b00xxxxx: alu_ctrl = 'b000; // lw sw
            'b01xxxxx: alu_ctrl = 'b001; // beq
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
