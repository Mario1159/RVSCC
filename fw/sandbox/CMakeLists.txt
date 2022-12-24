cmake_minimum_required(VERSION 3.10)

project(sandbox C)

set(SOURCE_FILES
    src/main.c
)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

target_compile_options(${PROJECT_NAME} PRIVATE
    -O0
    -march=rv32id
)

target_link_options(${PROJECT_NAME} PRIVATE
    -nostartfiles
    -static
    -Wl,-T${PROJECT_SOURCE_DIR}/linker-script.ld
    -Wl,-z,stack-size=64
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -S "$<TARGET_FILE:${PROJECT_NAME}>" > ${PROJECT_NAME}.disasm
        COMMENT "Invoking: Disassemble"
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -j .text
        -O verilog
        --verilog-data-width=1
        --reverse-bytes=4
        "$<TARGET_FILE:${PROJECT_NAME}>" ${PROJECT_NAME}.mem
    COMMENT "Invoking: Verilog Hexdump"
)

