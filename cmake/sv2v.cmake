cmake_minimum_required(VERSION 3.10)

function(rvscc_sv2v)
  cmake_parse_arguments(ARGS_SV2V
    ""
    "INCLUDE_DIR;LIB_DIR;TOP;NAME"
    "SOURCES"
    ${ARGN}
  )
  add_custom_command(TARGET ${RVSCC_TARGET} POST_BUILD
        COMMAND sv2v 
            -I {INCLUDE_DIR}
            -y . -w {ARGS_SV2V_NAME}.v tt4_core.sv .\timescale.sv .\single_cycle_datapath.sv .\rv32i_defs.sv .\register_file.sv .\main_decoder.sv .\jump_control.sv .\imm_extend.sv .\control_unit.sv .\alu.sv .\alu_decoder.sv
        COMMENT "Invoking: Verilog Hexdump"
    )
endfunction