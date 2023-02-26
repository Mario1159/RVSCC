.section .text
.global main

main:
	# Assert -1..1 edge case

	# I-type
	addi x1, zero, 1
	addi x1, zero, 0
	addi x1, zero, -1

	# Try extension for the other types

	# S-type (can not be negative)
	sw x2, 0x7FA(zero)

	# B-type
	bne x3, x4, dummy_label

	# J-type
	j 0x0007FA
	# Negative jump doesn't fit
	# j 0x10DA60

dummy_label:
	nop

