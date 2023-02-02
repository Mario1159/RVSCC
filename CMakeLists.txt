cmake_minimum_required(VERSION 3.10)
project(rvscc)
include(ExternalProject)

ExternalProject_Add(firmware
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/fw
  BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/fw/build
  CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_SOURCE_DIR}/fw/cmake/riscv-toolchain.cmake
  STEP_TARGETS build
  INSTALL_COMMAND ""
)

add_subdirectory(test)
