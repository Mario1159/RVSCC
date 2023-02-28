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
    "NAME;TOP"
    "SOURCES"
    ${ARGN}
  )
  set(TEST_TARGET_NAME test-${TEST_NAME})
  add_executable(${TEST_TARGET_NAME} sim_main.cpp)
  verilate(${TEST_TARGET_NAME}
    SOURCES ${TEST_SOURCES}
	PREFIX verilator_${TEST_TOP}
	TOP_MODULE ${TEST_TOP}
	TRACE
	VERILATOR_ARGS --timing --assert -I${PROJECT_SOURCE_DIR}/hwinc
  )
  target_compile_definitions(${TEST_TARGET_NAME} PRIVATE
    TEST_HEADER="verilator_${TEST_TOP}.h"
    TEST_CLASS=verilator_${TEST_TOP}
  )
  add_test(NAME ${TEST_TARGET_NAME} COMMAND ${TEST_TARGET_NAME})
endfunction()
