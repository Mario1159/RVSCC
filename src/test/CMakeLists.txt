include(${PROJECT_SOURCE_DIR}/cmake/utils.cmake)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(SystemCLanguage QUIET)

rvscc_add_test(
  NAME alu
  TOP test_alu
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
		  ${PROJECT_SOURCE_DIR}/rtl/alu.sv  
		  ${PROJECT_SOURCE_DIR}/test/test_alu.sv
)

rvscc_add_test(
	NAME imm-extend
	TOP test_imm_extend
	SOURCES ${PROJECT_SOURCE_DIR}/rtl/imm_extend.sv
			${PROJECT_SOURCE_DIR}/test/test_imm_extend.sv
)

rvscc_add_test(
  NAME register-file
  TOP test_register_file
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
          ${PROJECT_SOURCE_DIR}/rtl/register_file.sv
  		  ${PROJECT_SOURCE_DIR}/test/test_register_file.sv
)

rvscc_add_test(
  NAME single-cycle-core
  TOP test_single_cycle_core
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
		  ${PROJECT_SOURCE_DIR}/rtl/single_cycle_datapath.sv
          ${PROJECT_SOURCE_DIR}/rtl/data_memory_if.sv
          ${PROJECT_SOURCE_DIR}/rtl/data_memory.sv
          ${PROJECT_SOURCE_DIR}/rtl/instr_memory_if.sv
          ${PROJECT_SOURCE_DIR}/rtl/instr_memory.sv
          ${PROJECT_SOURCE_DIR}/rtl/jump_control.sv
          ${PROJECT_SOURCE_DIR}/rtl/control_unit.sv
  		  ${PROJECT_SOURCE_DIR}/rtl/alu_decoder.sv
  		  ${PROJECT_SOURCE_DIR}/rtl/main_decoder.sv
          ${PROJECT_SOURCE_DIR}/rtl/register_file.sv
          ${PROJECT_SOURCE_DIR}/rtl/imm_extend.sv
          ${PROJECT_SOURCE_DIR}/rtl/alu.sv  
  		  ${PROJECT_SOURCE_DIR}/test/test_single_cycle_core.sv
)