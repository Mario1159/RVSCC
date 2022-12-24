# Collection of SystemVerilog basic RV32I CPU cores
- Single cycle processor
- 5-Stage  pipelined processor with hazard detection


## Directory Structure
    .
    ├── fw                   # Firmware
    │   ├── sandbox          # C/Assembly sandbox firmware source
    │   └── test             # Assembly programs used for testbenchs
    ├── rtl                  # RTL Modules
    └── test                 # SystemVerilog testbenchs

## Requirements
- SystemVerilog simulator
- CMake
- 32-bit GNU RISC-V toolchain

If your package manager does not provide the RISC-V GNU toolchain you can compile it from their [main repository](https://github.com/riscv-collab/riscv-gnu-toolchain) or for Windows you can download the [xPack pre-compiled binaries](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases).

## Build
To build the firmware that will be loaded in the instruction memory execute CMake in the `fw` directory specifying the RISC-V toolchain and build the recipe based in your selected generator (`make` in the following example).
```
cmake -DCMAKE_TOOLCHAIN_FILE=./cmake/toolchain.cmake -Bbuild
make -Cbuild
```
## Testing
(TODO)
## Benchmark
(TODO)