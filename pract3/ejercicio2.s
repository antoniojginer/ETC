	.globl __start
	.data 0x10000000
.asciiz "="
.asciiz "M"
.asciiz "Q"
.asciiz "R"
.asciiz "space" 
	.text 0x00400000	
__start:	
		jal InputM
	li $v0, 5
	syscall
	move $t0, $v0
		jal InputQ
	li $v0, 5
	syscall
	move $t1, $v0
		jal Prompt
	li $v0, 10
	syscall 
InputM:
	li $v0, 11
	la $a0, M
	syscall
	la $a0, =
	syscall
		jr $ra

InputQ:	
	li $v0, 11
	la $a0, Q
	syscall
	la $a0, =
	syscall
		jr $ra	

Prompt:
	mult $t0, $t1
	mflo $t1
	li $v0, 11
	la $a0, R
	syscall
	la $a0, =
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
		jr $ra
	
	
	
	
		