include(${PROJECT_SOURCE_DIR}/cmake/utils.cmake)

rvscc_sv2v(
    timescale.sv
    single_cycle_datapath.sv
    rv32i_defs.sv
    register_file.sv
    main_decoder.sv
    jump_control.sv
    imm_extend.sv
    control_unit.sv
    alu.sv
    alu_decoder.sv
)
