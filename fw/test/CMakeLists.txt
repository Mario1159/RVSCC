cmake_minimum_required(VERSION 3.10)

project(test ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/utils.cmake)

option(DISSASEMBLY "Enable dissasembly" OFF)

list(APPEND TEST_FILES
    itype.s
    rtype.s
	imm.s
	core.s
)

foreach(TEST_FILE IN LISTS TEST_FILES)
	get_filename_component(TEST_FILENAME ${TEST_FILE} NAME_WE)
	set(TEST_TARGET "test-${TEST_FILENAME}")

	add_executable(${TEST_TARGET} ${TEST_FILENAME}.s)

    target_compile_options(${TEST_TARGET} PRIVATE
      -march=rv32id
    )

    target_link_options(${TEST_TARGET} PRIVATE
        -T ${CMAKE_SOURCE_DIR}/linker-script.ld
    )

    if(DISSASEMBLY)
      rvscc_dissasemble(TARGET ${TEST_TARGET})
    endif()
    rvscc_bin_to_verilog_mem_file(TARGET ${TEST_TARGET})
endforeach()
