set(CMAKE_SYSTEM_NAME Generic)

find_program(RISCV_GCC_FOUND
  NAMES riscv-none-elf-gcc riscv32-unknown-linux-gnu-gcc)

get_filename_component(GCC_BIN ${RISCV_GCC_FOUND} NAME)

message("msg gcc: ${GCC_BIN}")

string(REPLACE gcc "" TOOLCHAIN_PREFIX ${GCC_BIN})

message("msg toolchain: ${TOOLCHAIN_PREFIX}")

set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_OBJDUMP      ${TOOLCHAIN_PREFIX}objdump)
