set(CMAKE_SYSTEM_NAME Generic)

set(TOOLCHAIN_PREFIX riscv32-unknown-linux-gnu-)

set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
