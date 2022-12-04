cmake_minimum_required(VERSION 3.10)

project(rv32fw C)

add_executable(${PROJECT_NAME} src/main.c)

target_compile_options(${PROJECT_NAME} PRIVATE -Os)
target_link_options(${PROJECT_NAME} PRIVATE -nostdlib)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -j .text -O verilog --verilog-data-width=4 "$<TARGET_FILE:${PROJECT_NAME}>" rv32fw.hex
    COMMENT "Invoking: Verilog Hexdump"
    VERBATIM)
