`timescale 1ns / 1ps

module SingleCycleCPU(
    input logic clk, reset
);
    logic[31:0] pc, pc_next;
    logic[31:0] imm_ext;
    logic[31:0] pc_target;
    assign pc_target = imm_ext + pc;

    always_comb begin
        case(pc_src)
            'd0: pc_next = pc + 'd4;
            'd1: pc_next = pc_target;
        endcase
    end

    always_ff @(posedge clk) begin
        if(reset)
            pc <= 'b0;
        else
            pc <= pc_next;
    end

    logic[31:0] instr;
    InstructionMemory  #(.N(32)) instruction_memory(pc, instr);

    logic reg_write;
    logic[31:0] read_data_1, read_data_2;
    logic[31:0] result;
    RegisterFile #(.N_REG_ADDR(5), .N_DATA(32)) register_file(
        clk,
        reset,
        instr[19:15],
        instr[24:20],
        instr[11:7],
        reg_write,
        result,
        read_data_1,
        read_data_2
    );

    logic[1:0] result_src;
    logic[1:0] imm_src;
    logic[2:0] alu_ctrl;
    logic alu_status_zero;
    ControlUnit control_unit(
        instr[6:0],
        instr[14:12],
        instr[31:25],
        result_src,
        mem_write,
        alu_ctrl,
        alu_src,
        imm_src,
        reg_write,
        jump,
        branch,
        branch_alu_neg
    );
    
    JumpControl jump_control(
        jump,
        branch,
        branch_alu_neg,
        alu_status_zero,
        pc_src);

    Extend imm_extend(
        imm_src[1:0],
        instr[31:7],
        imm_ext[31:0]
    );

    //logic[31:0] src_a = read_data_1;
    logic[31:0] src_b;
    always_comb begin
        case(alu_src)
            'd0: src_b = read_data_2;
            'd1: src_b = imm_ext;
        endcase
    end

    logic[31:0] alu_result;
    logic[3:0] alu_status;
    assign alu_status_zero = alu_status[2];
    ALU alu(
        read_data_1,
        src_b,
        alu_ctrl,
        alu_result,
        alu_status
    );

    logic[31:0] write_data;
    assign write_data = read_data_2;
    logic[31:0] data_mem_read_data;
    DataMemory data_memory(
        clk,
        reset,
        alu_result,
        mem_write,
        write_data,
        data_mem_read_data
    );
    
    always_comb begin
        case(result_src)
            'b00: result = alu_result;
            'b01: result = data_mem_read_data;
            'b10: result = pc + 'd4;
            'b11: result = 'dx;
        endcase
    end
endmodule
