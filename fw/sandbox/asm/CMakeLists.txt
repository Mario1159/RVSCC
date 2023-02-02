cmake_minimum_required(VERSION 3.10)

project(sandbox_asm ASM)
include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/utils.cmake)

set(SOURCE_FILES main.s)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

target_compile_options(${PROJECT_NAME} PRIVATE
  -march=rv32id
)

target_link_options(${PROJECT_NAME} PRIVATE
  -T ${CMAKE_CURRENT_SOURCE_DIR}/../../linker-script.ld
)

rvscc_bin_to_verilog_mem_file(TARGET ${PROJECT_NAME})
