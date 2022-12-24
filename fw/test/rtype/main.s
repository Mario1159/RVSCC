.section .text
.global main

main:
    addi t0, zero, 21
    addi t1, zero, 72
    add t2, t0, t1
    # check t2 == 83
