# Collection of SystemVerilog simple RV32I CPU cores

## Table of contents
- [Core list](#core-list)
- [Directory structure](#directory-structure)
- [Requirements](#requirements)
- [Build](#build)
- [Tests](#tests)
- [Benchmark](#benchmark)

## Core list
- Single cycle processor
- 5-Stage pipelined processor with hazard detection
- 5-Stage pipelined processor with N-way associative cache

## Directory structure
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

> If your package manager does not provide the RISC-V GNU toolchain you can compile it from their [main repository](https://github.com/riscv-collab/riscv-gnu-toolchain) or for Windows you can download the [xPack pre-compiled binaries](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases).

### Docker enviroment

There is a docker enviroment image with all the dependencies already pre-installed.
For getting docker check their [installation instruction site](https://docs.docker.com/get-docker/).
> **Tip:** If you run into problems running docker make sure you have:
> - **WSL2** installed in case of Windows
> - **Secure Boot disabled** and **Virtualization enabled** in your BIOS settings

To set up the enviroment pull the image from the container registry and run it:
```
docker pull git.1159.cl/mario1159/rvscc
docker run -it git.1159.cl/mario1159/rvscc
```

## Build
To build the firmware that will be loaded in the instruction memory execute CMake in the `fw` directory specifying the RISC-V toolchain and build the recipe based in your selected generator (`make` in the following example).
```
cmake -Bbuild
cmake --build build
```
This will generate a `sandbox.mem` file in the `/build` folder. To load the file in the simulation make sure to add it to your simulator sources and that the memory path matches the path specifies in the memory module.
## Tests
```
ctest --test-dir build
```
## Benchmark
(TODO)
