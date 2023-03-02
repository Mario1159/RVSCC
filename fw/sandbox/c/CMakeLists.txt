include(${PROJECT_SOURCE_DIR}/../cmake/utils.cmake)

set(SOURCE_FILES
    main.c
)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

target_compile_options(${PROJECT_NAME} PRIVATE
    -O0
    -march=rv32id
)

target_link_options(${PROJECT_NAME} PRIVATE
    -nostartfiles
    -static
    -Wl,-T${CMAKE_CURRENT_SOURCE_DIR}/../../linker-script.ld
    -Wl,-z,stack-size=64
)

rvscc_dissasemble(TARGET ${PROJECT_NAME})
rvscc_bin_to_verilog_mem_file(TARGET ${PROJECT_NAME})
