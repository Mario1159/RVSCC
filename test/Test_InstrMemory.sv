`timescale 1ns / 1ps

module Test_InstrMemory();
    logic[31:0] addr;
    logic[31:0] instr;
    
    InstructionMemory instruction_memory(
        .addr(addr),
        .instr(instr)
        );
    
    initial begin
        addr='d1;
        #20
        addr='d11;
        #20 
        addr='d12;
        #20 
        addr='d13;
    end
endmodule
