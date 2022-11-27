cmake_minimum_required(VERSION 3.10)

project(riscv-program C)

set (CMAKE_C_FLAGS "-Os -g -Wall -ffunction-sections")
set(CMAKE_TOOLCHAIN_FILE "cmake/riscv.cmake")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostartfiles -fno-exceptions -Xlinker")

add_executable(${PROJECT_NAME} src/main.c)