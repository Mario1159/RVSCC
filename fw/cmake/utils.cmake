cmake_minimum_required(VERSION 3.10)

function(rvscc_bin_to_verilog_mem_file)
  cmake_parse_arguments(RVSCC
    ""
    "TARGET"
    ""
    ${ARGN}
  )
  add_custom_command(TARGET ${RVSCC_TARGET} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -j .text
            -O verilog
            --verilog-data-width=1
            --reverse-bytes=4
            "$<TARGET_FILE:${RVSCC_TARGET}>" ${RVSCC_TARGET}.mem
        COMMENT "Invoking: Verilog Hexdump"
    )
endfunction()

function(rvscc_dissasemble)
  cmake_parse_arguments(RVSCC
    ""
    "TARGET"
    ""
    ${ARGN}
  )
  add_custom_command(TARGET ${RVSCC_TARGET} POST_BUILD
    COMMAND ${CMAKE_OBJDUMP} -S "$<TARGET_FILE:${RVSCC_TARGET}>" > ${RVSCC_TARGET}.disasm
          COMMENT "Invoking: Disassemble"
  )
endfunction()
