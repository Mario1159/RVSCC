import rv32i_defs::*;

module instr_memory #(
    parameter int N_INSTR = 32,
    parameter string FILE_PATH = ""
) (
    input logic [$clog2(N_INSTR * 4)-1:0] addr,
    output logic [InstructionSize-1:0] instr
);
  // Number of bits referenced with one address
  localparam int BlockSize = 8;
  localparam int NumBlocks = N_INSTR * 4;
  logic [BlockSize-1:0] mem[NumBlocks];

  assign instr = {mem[addr+'d0], mem[addr+'d1], mem[addr+'d2], mem[addr+'d3]};

  initial $readmemh(FILE_PATH, mem);
endmodule
