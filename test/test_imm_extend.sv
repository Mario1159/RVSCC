`timescale 1ns / 1ps

module test_imm_extend();
  logic [ 1:0] imm_src;
  logic [31:0] instr;
  logic [31:0] imm_ext;

  imm_extend DUT (
      .imm_src(imm_src),
      .instr  (instr[31:7]),
      .imm_ext(imm_ext)
  );

  logic [7:0] mem[16*4];

  typedef struct packed {
    bit [1:0]  imm_src;
    bit [31:0] assert_imm_ext_value;
  } instr_info_t;

  instr_info_t [5:0] instr_info;
  typedef logic [31:0] instr_t;
  function static instr_t get_instr(int i);
    return {mem[i*4], mem[i*4+1], mem[i*4+2], mem[i*4+3]};
  endfunction

  initial begin
    $dumpfile("test-imm-extend.vcd");
    $dumpvars(1, DUT);

    $readmemh("../fw/test/test-imm.mem", mem);
    instr_info = '{
        // instr_info_t'{2'h3, 32'hFFFF_FFE2},
        instr_info_t'{2'h3, 32'h0000_07E6},
        instr_info_t'{2'h2, 32'h0000_0008},
        instr_info_t'{2'h1, 32'h0000_07FA},
        instr_info_t'{2'h0, 32'hFFFF_FFFF},
        instr_info_t'{2'h0, 32'h0000_0000},
        instr_info_t'{2'h0, 32'h0000_0001}
    };

    #1;
    assert (mem[0] !== 8'dx)
    else $error("Test firmware not loaded");

    for (int i = 0; i < 6; i++) begin
      instr   = get_instr(i);
      imm_src = instr_info[i].imm_src;
      #1;
      assert (instr_info[i].assert_imm_ext_value == imm_ext)
      else $error("Failed at instruction %d", i + 1);
      #1;
    end
    $finish;
  end
endmodule
