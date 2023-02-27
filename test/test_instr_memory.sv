`timescale 1ns / 1ps

import rv32i_defs::*;

module test_instr_memory ();
  localparam string Path = "../fw/test/test-core.mem";
  localparam int NumInstr = 32;
  localparam int NumBlocks = NumInstr * 4;
  localparam int AddrSize = $clog2(NumBlocks);

  logic [AddrSize-1:0] addr;
  logic [InstructionSize-1:0] instr;

  instr_memory_if #(.NUM_INSTR(NumInstr)) dut_if();

  instr_memory #(
      .FILE_PATH(Path),
      .NUM_INSTR(NumInstr)
  ) dut (
      .instr_mem_if(dut_if.mem)
  );

  const
  int
  assert_instr_mem[21] = {
    'h00500113,
    'h00C00193,
    'hFF718393,
    'h0023E233,
    'h0041F2B3,
    'h004282B3,
    'h02728863,
    'h0041A233,
    'h00020463,
    'h00000293,
    'h0023A233,
    'h005203B3,
    'h402383B3,
    'h0471AA23,
    'h06002103,
    'h005104B3,
    'h008001EF,
    'h00100113,
    'h00910133,
    'h0221A023,
    'h00210063
  };

  initial begin
    dut_if.addr = 'd0;
    #1
    assert (!$isunknown(dut_if.instr))
    else $error("Instruction memory not loaded");
    #1;
    foreach (assert_instr_mem[i]) begin
      #1
      assert (dut_if.instr == assert_instr_mem[i])
      else
        $error(
            "Instruction %h at address %h does not match the expected intruction %h",
            dut_if.instr,
            dut_if.addr,
            assert_instr_mem[i]
        );
      dut_if.next_instr();
    end
    $finish;
  end
endmodule
