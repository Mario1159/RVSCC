cmake_minimum_required(VERSION 3.10)

project(rvscc-tests CXX)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(SystemCLanguage QUIET)

function(rvscc_add_test)
  cmake_parse_arguments(TEST
    ""
    "NAME"
    "SOURCES"
    ${ARGN}
  )
  set(TEST_TARGET_NAME test-${TEST_NAME})
  add_executable(${TEST_TARGET_NAME} sim_main.cpp)
  verilate(${TEST_TARGET_NAME}
    SOURCES ${TEST_SOURCES}
	TRACE
    VERILATOR_ARGS --timing --assert
  )
  list(GET TEST_SOURCES 0 TEST_TOP_MODULE)
  get_filename_component(TEST_TOP_MODULE_NAME ${TEST_TOP_MODULE} NAME_WE)
  target_compile_definitions(${TEST_TARGET_NAME} PRIVATE
    TEST_HEADER="V${TEST_TOP_MODULE_NAME}.h"
    TEST_CLASS=V${TEST_TOP_MODULE_NAME}
  )
  add_test(NAME ${TEST_TARGET_NAME} COMMAND ${TEST_TARGET_NAME})
endfunction()

rvscc_add_test(
  NAME alu
  TOP Test_ALU
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/RV32IDefs.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/Test_ALU.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/ALU.sv  
)

rvscc_add_test(NAME priority-encoder
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Test_PriorityEncoder.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/PriorityEncoder.sv
)

rvscc_add_test(NAME data-memory
	SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Test_DataMemory.sv
			    ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/DataMemory.sv
)

rvscc_add_test(NAME imm-extend
	SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Test_ImmExtend.sv
			    ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/ImmExtend.sv
)

rvscc_add_test(
  NAME register-file
  TOP Test_RegisterFile
  SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Test_RegisterFile.sv
          ${CMAKE_CURRENT_SOURCE_DIR}/../rtl/RegisterFile.sv
)
