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
  NAME priority-encoder
  TOP test_priority_encoder
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/priority_encoder.sv
          ${PROJECT_SOURCE_DIR}/test/test_priority_encoder.sv
)

rvscc_add_test(
  NAME data-memory
  TOP test_data_memory
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv 
          ${PROJECT_SOURCE_DIR}/rtl/data_memory_if.sv
          ${PROJECT_SOURCE_DIR}/rtl/data_memory.sv
   	      ${PROJECT_SOURCE_DIR}/test/test_data_memory.sv
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
  NAME instruction_memory TOP test_instr_memory
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
          ${PROJECT_SOURCE_DIR}/rtl/instr_memory_if.sv
          ${PROJECT_SOURCE_DIR}/rtl/instr_memory.sv
  		  ${PROJECT_SOURCE_DIR}/test/test_instr_memory.sv
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

rvscc_add_test(
  NAME five-stage-pipeline-core
  TOP test_five_stage_pipeline_core
  SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
          ${PROJECT_SOURCE_DIR}/rtl/five_stage_pipeline_datapath.sv
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
          ${PROJECT_SOURCE_DIR}/rtl/hazard_unit.sv  
  		  ${PROJECT_SOURCE_DIR}/test/test_five_stage_pipeline_core.sv
)

rvscc_add_test(
	NAME cache-memory
	TOP test_cache_memory
	SOURCES ${PROJECT_SOURCE_DIR}/rtl/cache_memory.sv
  			${PROJECT_SOURCE_DIR}/rtl/priority_encoder.sv
	        ${PROJECT_SOURCE_DIR}/test/test_cache_memory.sv
)

rvscc_add_test(
	NAME two-way-lru-cache
	TOP test_two_way_lru_cache
  	SOURCES ${PROJECT_SOURCE_DIR}/rtl/rv32i_defs.sv
			${PROJECT_SOURCE_DIR}/rtl/two_way_lru_cache.sv
			${PROJECT_SOURCE_DIR}/rtl/two_way_lru_cru.sv
            ${PROJECT_SOURCE_DIR}/rtl/data_memory_if.sv
			${PROJECT_SOURCE_DIR}/rtl/cache_memory.sv
			${PROJECT_SOURCE_DIR}/rtl/cache_controller.sv
  			${PROJECT_SOURCE_DIR}/rtl/priority_encoder.sv
	        ${PROJECT_SOURCE_DIR}/test/test_two_way_lru_cache.sv
)
