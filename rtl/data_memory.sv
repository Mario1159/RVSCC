import rv32i_defs::*;

module data_memory #(
    parameter int BLOCK_SIZE = 8,
    parameter int NUM_BLOCKS = 32
) (
    data_memory_if.ram mem_if
);
  logic [NUM_BLOCKS-1:0][BLOCK_SIZE-1:0] mem;

  assign mem_if.read_data = {
    mem[mem_if.addr+'d3], mem[mem_if.addr+'d2], mem[mem_if.addr+'d1], mem[mem_if.addr+'d0]
  };
  always_ff @(posedge mem_if.clk) begin
    if (mem_if.rst) mem <= '{default: '0};
    else if (mem_if.write_enable)
      {mem[mem_if.addr+'d3],
       mem[mem_if.addr+'d2],
       mem[mem_if.addr+'d1],
       mem[mem_if.addr+'d0]} <= mem_if.write_data;
  end
endmodule
