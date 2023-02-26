.section .text
.global main

main:
    addi t0, zero, 96
    # check t0 == 'b01100000

    nop
    nop

    xori t1, t0, -1 
    # check t1 == 'b10011111

    ori t2, t0, 192 
    # check t2 == 'b11100000
