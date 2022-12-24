set(CMAKE_SYSTEM_NAME Generic)

if (UNIX)
    set(TOOLCHAIN_PREFIX riscv32-unknown-linux-gnu-)
endif()
if (WIN32)
    set(TOOLCHAIN_PREFIX riscv-none-elf-)
endif()

set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_OBJDUMP      ${TOOLCHAIN_PREFIX}objdump)
