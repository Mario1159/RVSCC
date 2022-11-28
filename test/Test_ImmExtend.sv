`timescale 1ns / 1ps

module Test_ImmExtend();
    logic[1:0] imm_src;
    logic[31:0] instr;
    logic[31:0] imm_ext;
    
    Extend imm_extend(
        .imm_src(imm_src),
        .instr(instr[31:7]),
        .imm_ext(imm_ext)
    );
    
    initial begin
        instr='h00a00893;
        #20        
        imm_src='d0;
        #20 
        imm_src='d1; 
        #20 
        imm_src='d2;
    end
endmodule
