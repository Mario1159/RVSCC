.section .text
.global main

main:
    mv t0, 21
    mv t1, 72
    add t2, t0, t1
    # check t2 == 83
