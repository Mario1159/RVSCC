cmake_minimum_required(VERSION 3.10)

project(rv32fw C)

set(CMAKE_C_FLAGS "-Os -g -Wall -ffunction-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostartfiles -fno-exceptions -Xlinker")

add_executable(${PROJECT_NAME} src/main.c)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -j .text -O verilog --verilog-data-width=4 ${PROJECT_NAME} ${PROJECT_NAME}.hex
    COMMENT "Invoking: Verilog Hexdump")
