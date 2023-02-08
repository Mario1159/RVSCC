cmake_minimum_required(VERSION 3.10)

function(rvscc_bin_to_verilog_mem_file)
  cmake_parse_arguments(RVSCC
    ""
    "TARGET"
    ""
    ${ARGN}
  )
  add_custom_command(TARGET ${RVSCC_TARGET} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -j .text
            -O verilog
            --verilog-data-width=1
            --reverse-bytes=4
            "$<TARGET_FILE:${RVSCC_TARGET}>" ${RVSCC_TARGET}.mem
        COMMENT "Invoking: Verilog Hexdump"
    )
endfunction()

function(rvscc_dissasemble)
  cmake_parse_arguments(RVSCC
    ""
    "TARGET"
    ""
    ${ARGN}
  )
  add_custom_command(TARGET ${RVSCC_TARGET} POST_BUILD
    COMMAND ${CMAKE_OBJDUMP} -S "$<TARGET_FILE:${RVSCC_TARGET}>" > ${RVSCC_TARGET}.disasm
          COMMENT "Invoking: Disassemble"
  )
endfunction()

function(rvscc_add_test)
  cmake_parse_arguments(TEST
    ""
    "NAME"
    "SOURCES"
    ${ARGN}
  )
  message("Adding test ${TEST_NAME}")
  set(TEST_TARGET_NAME test-${TEST_NAME})
  add_executable(${TEST_TARGET_NAME} sim_individual_test.cpp)
  if ("${CMAKE_BUILD_TYPE}" EQUAL "Release")
    verilate(${TEST_TARGET_NAME}
      SOURCES ${TEST_SOURCES}
      SYSTEMC
      VERILATOR_ARGS --timing
    )
  else() # Debug
    verilate(${TEST_TARGET_NAME}
      SOURCES ${TEST_SOURCES}
      TRACE
      SYSTEMC
      VERILATOR_ARGS --timing
    )
  endif()
  set_property(TARGET ${TEST_TARGET_NAME} PROPERTY CXX_STANDARD ${SystemC_CXX_STANDARD})
  verilator_link_systemc(${TEST_TARGET_NAME})
  list(GET TEST_SOURCES 0 TEST_TOP_MODULE)
  get_filename_component(TEST_TOP_MODULE_NAME ${TEST_TOP_MODULE} NAME_WE)
  target_compile_definitions(${TEST_TARGET_NAME} PRIVATE
    TEST_HEADER="V${TEST_TOP_MODULE_NAME}.h"
    TEST_CLASS=V${TEST_TOP_MODULE_NAME}
  )
  add_test(NAME ${TEST_TARGET_NAME} COMMAND ${TEST_TARGET_NAME})
endfunction()
