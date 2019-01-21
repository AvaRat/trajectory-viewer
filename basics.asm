.data
frameBuffer: .space 0x90000
prompt_vx: .asciiz "enter Vx[*0.1m/s] \n"
prompt_vy: .asciiz "enter Vy[*0.1m/s] \n"
prompt_L: .asciiz "enter loss of speed [%] \n"
prompt_xy: .asciiz "(x,y) "
bounce_v: .asciiz "(Vx,Vy) "
bounce_check: .asciiz "******BOUNCE_CHECK*******\n"
file_result_test: .asciiz "******* file test: (x <0 -> error\t x -> nr of characters written/saved/file_descriptor\n"
.text

# %r is what is supposed to be
.macro FILE_TEST(%f)
	move $t1, %f
	la $a0, file_result_test
	li $v0, 4
	syscall
	
	add $a0, $zero, $t1
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall

.end_macro	
	

.macro BOUNCE_CHECK(%x, %y, %vx, %vy)
	la $a0, bounce_check
	li $v0, 4
	syscall
	
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
#################
	la $a0, bounce_v
	li $v0, 4
	syscall
	
	li $a0, '('
	li $v0, 11
	syscall
	
	move $a0, %vx
	li $v0, 1
	syscall
	
	li $a0, ','
	li $v0, 11
	syscall	
	
	move $a0, %vy
	li $v0, 1
	syscall
	
	li $a0, ')'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall	
	li $a0, '\n'
	li $v0, 11
	syscall	
.end_macro

.macro ASK_GET_Vx(%x)
	li $v0, 4
	la $a0, prompt_vx
	syscall
	li $v0, 5
	syscall
	move %x, $v0
	sll %x, %x, 10
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
	sll %x, %x, 10
.end_macro

.macro ASK_GET_L(%l)
	la $a0, prompt_L
	li $v0, 4
	syscall
	li $v0, 5
	syscall	
	move %l, $v0
	sll %l, %l, 10
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


