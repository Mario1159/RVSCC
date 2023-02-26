include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/utils.cmake)

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
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/rv32i_defs.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/alu.sv  
          ${CMAKE_CURRENT_SOURCE_DIR}/test_alu.sv
)

rvscc_add_test(
  NAME priority-encoder
  TOP test_priority_encoder
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/priority_encoder.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/test_priority_encoder.sv
)

rvscc_add_test(
  NAME data-memory
  TOP test_data_memory
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/rv32i_defs.sv 
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/data_memory_if.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/data_memory.sv
   	      ${CMAKE_CURRENT_SOURCE_DIR}/test_data_memory.sv
)

rvscc_add_test(
	NAME imm-extend
	TOP test_imm_extend
	SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/imm_extend.sv
			${CMAKE_CURRENT_SOURCE_DIR}/test_imm_extend.sv
)

rvscc_add_test(
  NAME register-file
  TOP test_register_file
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/rv32i_defs.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/register_file.sv
  		  ${CMAKE_CURRENT_SOURCE_DIR}/test_register_file.sv
)

rvscc_add_test(
  NAME instruction_memory
  TOP test_instr_memory
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/rv32i_defs.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/instr_memory.sv
  		  ${CMAKE_CURRENT_SOURCE_DIR}/test_instr_memory.sv
)

rvscc_add_test(
  NAME single-cycle-core
  TOP test_single_cycle_core
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/rv32i_defs.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/single_cycle_datapath.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/data_memory_if.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/data_memory.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/instr_memory.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/jump_control.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/control_unit.sv
  		  ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/alu_decoder.sv
  		  ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/main_decoder.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/register_file.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/imm_extend.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/alu.sv  
  		  ${CMAKE_CURRENT_SOURCE_DIR}/test_single_cycle_core.sv
)
