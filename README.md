---
gitea: none
title: hello
include_toc: true
---
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)

# RISC-V Simple Core Collection

Collection of SystemVerilog RV32I cores and modules

## Features
- Single cycle processor
- 5-Stage pipelined processor with hazard detection
- N-Way associative cache memory

## Directory structure
    .
    ├── fw                   # Firmware
    │   ├── sandbox          # C/Assembly sandbox firmware source
    │   └── test             # Assembly programs used for testbenchs
    ├── include              # SystemVerilog include directory
    ├── rtl                  # SystemVerilog RTL modules
    ├── scripts              # Utility scripts
    └── test                 # SystemVerilog testbenchs

## Requirements
- Verilator or another SystemVerilog simulator
- CMake
- 32-bit GNU RISC-V toolchain

> If your package manager does not provide the RISC-V GNU toolchain you can either download the binaries from the [xPack GNU RISC-V Embedded GCC](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases) package or it can be compiled from their [main repository](https://github.com/riscv-collab/riscv-gnu-toolchain). Also you can take a look to the [docker enviroment](#docker-enviroment) provided.

### Docker enviroment

There is a docker enviroment image with all the dependencies already pre-installed.
For getting docker check their [installation instruction site](https://docs.docker.com/get-docker/).
> **Tip:** If you run into problems running docker make sure you have:
> - **WSL2** installed in case of Windows
> - **Secure Boot disabled** and **Virtualization enabled** in your BIOS settings

To set up the enviroment you can create a [dev enviroment](https://docs.docker.com/desktop/dev-environments) pointing to this repository or you can pull the image directly from the container registry and then run it:
```
docker pull git.1159.cl/mario1159/rvscc
docker run -it git.1159.cl/mario1159/rvscc
```

## Build
To build the firmware that will be loaded in the instruction memory and the simulation testbenchs execute CMake in the project root directory using your system default toolchain (the [CMake toolchain file](cmake/riscv-toolchain.cmake) will search automatically for a RISC-V toolchain to build the firmware).
```
cmake -Bbuild
cmake --build build
```
This will generate a `sandbox.mem` file in the `/build/fw/sandbox` folder. For other simulators than Verilator make sure to add the firmware into your simulator sources and that the memory path matches the path specified in the memory module.

## Tests
After building, tests can be runned using CMake CTest.
```
ctest --test-dir build
```

## Sandbox
For experimenting with a custom firmware, configure the project with one from the following options and use the examples in the [sandbox](fw/sandbox) folder.
```
cmake -Bbuild [-DSANDBOX_ASM=ON] [-DSANDBOX_C=ON]
```

## Documentation
More information including documentation about each module can be found in the [Wiki](https://git.1159.cl/Mario1159/RVSCC/wiki).