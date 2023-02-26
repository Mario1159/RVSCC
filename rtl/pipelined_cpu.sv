`timescale 1ns / 1ps

module PipelinedCPU(
    input logic clk, reset
);
    logic[31:0] fetch_pc, fetch_pc_next;

    logic[31:0] fetch_pc_plus_4, execute_pc_target;
    always_comb begin
        fetch_pc_plus_4 = fetch_pc + 'd4;
        case(execute_pc_src)
            'd0: fetch_pc_next = fetch_pc_plus_4;
            'd1: fetch_pc_next = execute_pc_target;
        endcase
    end

    always_ff @(posedge clk) begin
        if(reset)
            fetch_pc <= 'b0;
        else if(!fetch_stall)
            fetch_pc <= fetch_pc_next;
    end

    logic[31:0] fetch_instr;
    InstructionMemory  #(.N(32)) instruction_memory(fetch_pc, fetch_instr);

    logic decode_stall, decode_flush;
    logic[31:0] decode_instr, decode_pc, decode_pc_plus_4;
    always_ff @(posedge clk) begin
        if(decode_flush) begin
            decode_instr <= 'd0;
            decode_pc <= 'd0;
            decode_pc_plus_4 <= 'd0;
        end else if(!decode_stall) begin
            decode_instr <= fetch_instr;
            decode_pc <= fetch_pc;
            decode_pc_plus_4 <= fetch_pc_plus_4;
        end
    end

    logic[4:0] decode_rs_1, decode_rs_2, decode_rd;
    assign decode_rs_1 = decode_instr[19:15];
    assign decode_rs_2 = decode_instr[24:20];
    assign decode_rd = decode_instr[11:7];

    logic writeback_reg_write;
    logic[31:0] decode_read_data_1, decode_read_data_2;
    logic[31:0] result, writeback_result;
    RegisterFile #(.N_REG_ADDR(5), .N_DATA(32)) register_file(
        ~clk,
        reset,
        decode_instr[19:15],
        decode_instr[24:20],
        writeback_rd,
        writeback_reg_write,
        writeback_result,
        decode_read_data_1,
        decode_read_data_2
    );

    logic[1:0] decode_result_src;
    logic[1:0] decode_imm_src;
    logic[2:0] decode_alu_ctrl;
    logic decode_reg_write, decode_branch_alu_neg;
    ControlUnit control_unit(
        .opcode(decode_instr[6:0]),
        .funct_3(decode_instr[14:12]),
        .funct_7(decode_instr[31:25]),
        .reg_write(decode_reg_write),
        .result_src(decode_result_src),
        .mem_write(decode_mem_write),
        .jump(decode_jump),
        .branch(decode_branch),
        .alu_ctrl(decode_alu_ctrl),
        .alu_src(decode_alu_src),
        .imm_src(decode_imm_src),
        .branch_alu_neg(decode_branch_alu_neg)
    );

    logic[31:0] decode_imm_ext;
    Extend imm_extend(
        decode_imm_src[1:0],
        decode_instr[31:7],
        decode_imm_ext[31:0]
    );
    
    logic execute_reg_write, execute_mem_write, execute_jump, execute_branch, execute_branch_alu_neg, execute_alu_src;
    logic[1:0] execute_result_src;
    logic[2:0] execute_alu_ctrl;
    logic[4:0] execute_rs_1, execute_rs_2, execute_rd;
    logic[31:0] execute_pc, execute_pc_plus_4, execute_read_data_1, execute_read_data_2, execute_imm_ext;
    always_ff @(posedge clk) begin
        if(execute_flush) begin
            execute_reg_write <= 'd0;
            execute_result_src <= 'd0;
            execute_mem_write <= 'd0;
            execute_jump <= 'd0;
            execute_branch <= 'd0;
            execute_alu_ctrl <= 'd0;
            execute_alu_src <= 'd0;
            execute_read_data_1 <= 'd0;
            execute_read_data_2 <= 'd0;
            execute_pc <= 'd0;
            execute_rs_1 <= 'd0;
            execute_rs_2 <= 'd0;
            execute_rd <= 'd0;
            execute_imm_ext <= 'd0;
            execute_pc_plus_4 <= 'd0;
        end else if (!decode_stall) begin
            execute_reg_write <= decode_reg_write;
            execute_result_src <= decode_result_src;
            execute_mem_write <= decode_mem_write;
            execute_jump <= decode_jump;
            execute_branch <= decode_branch;
            execute_branch_alu_neg <= decode_branch_alu_neg;
            execute_alu_ctrl <= decode_alu_ctrl;
            execute_alu_src <= decode_alu_src;
            execute_read_data_1 <= decode_read_data_1;
            execute_read_data_2 <= decode_read_data_2;
            execute_pc <= decode_pc;
            execute_rs_1 <= decode_rs_1;
            execute_rs_2 <= decode_rs_2;
            execute_rd <= decode_rd;
            execute_imm_ext <= decode_imm_ext;
            execute_pc_plus_4 <= decode_pc_plus_4;
        end
    end
    
    JumpControl jump_control(
        execute_jump,
        execute_branch,
        execute_branch_alu_neg,
        execute_zero,
        execute_pc_src
    );

    logic[31:0] execute_src_a, memory_alu_result;
    logic[1:0] execute_forward_a;
    always_comb begin
        case(execute_forward_a)
            'b00: execute_src_a = execute_read_data_1;
            'b01: execute_src_a = writeback_result;
            'b10: execute_src_a = memory_alu_result;
            'b11: execute_src_a = 'dx;
        endcase
    end
    
    logic[31:0] execute_write_data;
    logic[1:0] execute_forward_b;
    always_comb begin
        case(execute_forward_b)
            'b00: execute_write_data = execute_read_data_2;
            'b01: execute_write_data = writeback_result;
            'b10: execute_write_data = memory_alu_result;
            'b11: execute_write_data = 'dx;
        endcase
    end
    
    logic[31:0] execute_src_b;
    always_comb begin
        case(execute_alu_src)
            'd0: execute_src_b = execute_write_data;
            'd1: execute_src_b = execute_imm_ext;
        endcase
    end

    logic[31:0] execute_alu_result;
    logic[3:0] execute_alu_status;
    assign execute_zero = execute_alu_status[2];
    ALU alu(
        execute_src_a,
        execute_src_b,
        execute_alu_ctrl,
        execute_alu_result,
        execute_alu_status
    );
    
    assign execute_pc_target = execute_pc + execute_imm_ext;
    
    logic memory_reg_write, memory_mem_write;
    logic[1:0] memory_result_src;
    logic[4:0] memory_rd;
    logic[31:0] memory_pc_plus_4, memory_write_data;
    always_ff @(posedge clk) begin
        memory_reg_write <= execute_reg_write;
        memory_result_src <= execute_result_src;
        memory_mem_write <= execute_mem_write;
        memory_alu_result <= execute_alu_result;
        memory_write_data <= execute_write_data;
        memory_rd <= execute_rd;
        memory_pc_plus_4 <= execute_pc_plus_4;
    end

    logic[31:0] memory_read_data;
    DataMemory data_memory(
        clk,
        reset,
        memory_alu_result,
        memory_mem_write,
        memory_write_data,
        memory_read_data
    );
    
    logic[1:0] writeback_result_src;
    logic[4:0] writeback_rd;
    logic[31:0] writeback_pc_plus_4, writeback_alu_result, writeback_read_data;
    always_ff @(posedge clk) begin
        writeback_reg_write <= memory_reg_write;
        writeback_result_src <= memory_result_src;
        writeback_alu_result <= memory_alu_result;
        writeback_read_data <= memory_read_data;
        writeback_rd <= memory_rd;
        writeback_pc_plus_4 <= memory_pc_plus_4;
    end

    always_comb begin
        case(writeback_result_src)
            'b00: writeback_result = writeback_alu_result;
            'b01: writeback_result = writeback_read_data;
            'b10: writeback_result = writeback_pc_plus_4;
            'b11: writeback_result = 'dx;
        endcase
    end
    
    HazardUnit hazard_unit(
        reset,
        execute_pc_src, execute_result_src[0],
        memory_reg_write, writeback_reg_write,
        decode_rs_1, decode_rs_2,
        execute_rs_1, execute_rs_2,
        execute_rd, memory_rd, writeback_rd,
        fetch_stall, decode_stall,
        decode_flush, execute_flush,
        execute_forward_a, execute_forward_b
    );
        
endmodule
