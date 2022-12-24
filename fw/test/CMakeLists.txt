cmake_minimum_required(VERSION 3.10)

project(test ASM)

list(APPEND TEST_SUBDIRS
    itype
    rtype
)

foreach(TEST_SUBDIR IN LISTS TEST_SUBDIRS)
    set(TARGET "test-${TEST_SUBDIR}")
    add_executable(${TARGET} ${TEST_SUBDIR}/main.s)
    target_link_options(${TARGET} PRIVATE
        -nostartfiles
        -static
        -Wl,-T${CMAKE_SOURCE_DIR}/linker-script.ld
        -Wl,-z,stack-size=64
)
endforeach()
