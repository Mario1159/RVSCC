cmake_minimum_required(VERSION 3.10)

project(firmware)

option(TEST "Enable test firmware compilation" ON)
option(SANDBOX_ASM "Enable sandbox compilation using ASM language" OFF)
option(SANDBOX_C "Enable sandbox compilation using C language" OFF)

if (SANDBOX_ASM)
  add_subdirectory(sandbox/asm)
elseif (SANDBOX_C)
  add_subdirectory(sandbox/c)
endif()

if (TEST)
  add_subdirectory(test)
endif()
