.data
frameBuffer: .space 0x90000
prompt_vx: .asciiz "enter Vx \n"
prompt_vy: .asciiz "enter Vy \n"
prompt_L: .asciiz "enter loss of speed [%] \n"
prompt_xy: .asciiz "(x,y) "
.text


.macro ASK_GET_Vx(%x)
	li $v0, 4
	la $a0, prompt_vx
	syscall
	li $v0, 5
	syscall
	move %x, $v0
.end_macro

.macro PRINT_XY(%x, %y)
	la $a0, prompt_xy
	li $v0, 4
	syscall
	
	li $a0, '('
	li $v0, 11
	syscall
	
	move $a0, %x
	li $v0, 1
	syscall
	
	li $a0, ','
	li $v0, 11
	syscall	
	
	move $a0, %y
	li $v0, 1
	syscall
	
	li $a0, ')'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
.end_macro

.macro ASK_GET_Vy(%x)
	la $a0, prompt_vy
	li $v0, 4
	syscall
	li $v0, 5
	syscall	
	move %x, $v0
.end_macro

.macro ASK_GET_L(%l)
	la $a0, prompt_L
	li $v0, 4
	syscall
	li $v0, 5
	syscall	
	move %l, $v0
.end_macro

.macro PRINT_INT (%x)
	add $a0, $zero, %x
	li $v0, 1

	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
.end_macro


.macro END
	li $v0, 10
	syscall
.end_macro
