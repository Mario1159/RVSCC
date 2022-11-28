`timescale 1ns / 1ps

module MainDecoder(
    input logic[6:0] opcode,
    output logic branch,

    output logic jump,
    output logic[1:0] result_src,
    output logic mem_write,
    output logic[2:0] alu_ctrl,
    output logic alu_src,
    output logic[1:0] imm_src,
    output logic reg_write,
    output logic[1:0] alu_op
 );   
    always_comb begin
        case(opcode)
            'b0000011: begin // lw
                reg_write = 1;
                imm_src = 'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 'b01;
                branch = 0;
                alu_op = 'b00;
                jump = 0;
            end
            'b0100011: begin // sw
                reg_write = 0;
                imm_src = 'b01;
                alu_src = 1;
                mem_write = 1;
                result_src = 'bxx;
                branch = 0;
                alu_op = 'b00;
                jump = 0;
            end
            'b0110011: begin // r-type
                reg_write = 1;
                imm_src = 'bxx;
                alu_src = 0;
                mem_write = 0;
                result_src = 'b00;
                branch = 0;
                alu_op = 'b10;
                jump = 0;
            end
            'b1100011: begin // beq
                reg_write = 0;
                imm_src = 'b10;
                alu_src = 0;
                mem_write = 0;
                result_src = 'bxx;
                branch = 1;
                alu_op = 'b01;
                jump = 0;
            end
            'b0010011: begin // i-type
                reg_write = 1;
                imm_src = 'b00;
                alu_src = 1;
                mem_write = 0;
                result_src = 'b00;
                branch = 0;
                alu_op = 'b10;
                jump = 0;
            end
            'b1101111: begin // jal
                reg_write = 1;
                imm_src = 'b11;
                alu_src = 'bx;
                mem_write = 0;
                result_src = 'b10;
                branch = 0;
                alu_op = 'bxx;
                jump = 1;
            end
            default: begin
                reg_write = 'bx;
                imm_src = 'bxx;
                alu_src = 'bx;
                mem_write = 'bx;
                result_src = 'bx;
                branch = 'bx;
                alu_op = 'bx;
                jump = 'bx;
            end
        endcase
    end
endmodule
