`timescale 1ns / 1ps

// N = Bit width
module InstructionMemory #(
    parameter N = 32,
    parameter N_INSTR = 32,
    parameter BYTE_WIDTH = 8
)
(
    input logic[N-1:0] addr,
    output logic[N-1:0] instr
);
    logic[BYTE_WIDTH-1:0] mem [N_INSTR*BYTE_WIDTH-1:0];

    always_comb begin
        instr = {mem[addr + 'd0],
                 mem[addr + 'd1],
                 mem[addr + 'd2],
                 mem[addr + 'd3]};
    end

    initial $readmemh("rv32fw.mem", mem);
endmodule