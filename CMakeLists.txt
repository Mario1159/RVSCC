cmake_minimum_required(VERSION 3.10)
project(rvscc)

set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
include(CTest)
include(ExternalProject)

option(TEST "Enable test firmware compilation" ON)
option(SANDBOX_ASM "Enable sandbox compilation using ASM language" OFF)
option(SANDBOX_C "Enable sandbox compilation using C language" OFF)

ExternalProject_Add(firmware
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/fw
  BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/build/fw
  CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_SOURCE_DIR}/cmake/riscv-toolchain.cmake -DTEST=${TEST} -DSANDBOX_ASM=${SANDBOX_ASM} -DSANDBOX_C=${SANDBOX_C}
  INSTALL_COMMAND ""
)

add_subdirectory(test)
