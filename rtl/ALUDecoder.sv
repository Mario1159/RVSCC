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
            'b00xxxxx: begin
                alu_ctrl = 'b000; // lw sw
                branch_neg = 'dx;
            end
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
            'b1000000: begin
                alu_ctrl = 'b000; // add
                branch_neg = 'dx;
            end
            'b1000001: begin
                alu_ctrl = 'b000; // add
                branch_neg = 'dx;
            end
            'b1000010: begin
                alu_ctrl = 'b000; // add
                branch_neg = 'dx;
            end
            'b1000011: begin
                alu_ctrl = 'b001; // sub
                branch_neg = 'dx;
            end
            'b10010xx: begin
                alu_ctrl = 'b101; // slt
                branch_neg = 'dx;
            end
            'b10110xx: begin
                alu_ctrl = 'b000; // or
                branch_neg = 'dx;
            end
            'b10111xx: begin
                alu_ctrl = 'b000; // and
                branch_neg = 'dx;
            end
            default: begin 
                alu_ctrl = 'dx;
                branch_neg = 'dx;
            end
        endcase
    end
endmodule
