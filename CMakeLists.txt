cmake_minimum_required(VERSION 3.10)
project(rvscc)

set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)
include(CTest)
include(ExternalProject)

ExternalProject_Add(firmware
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/fw
  BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/build/fw
  CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_SOURCE_DIR}/fw/cmake/riscv-toolchain.cmake
  INSTALL_COMMAND ""
)

add_subdirectory(test)
