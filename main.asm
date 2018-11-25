.include "basics.asm"
.text
ASK_GET_Vx($s2)
ASK_GET_Vy($s3)
ASK_GET_L($s5)
	
	li $s1, -1 #white color

	la $s0, frameBuffer	##!!! dont touch !!!##
	li $t0, 0	# set time to 0
	addi $t5, $zero, 100	# 100 for percentage counting
	sub $t5, $t5, $s5	# for easier math (if L = 10%, then $s5->90)
	
# t6 -> X offset from (0,0)
# $t7 -> Y offset from (0,0)	
loop:	
	mul $t3, $s2, $t0	# x(t)
	div $t3, $t3, 10	#$t3 -> x(t) = Vx * t
	
	mul $t5, $s3, $t0	#Vy *t 
	div $t5, $t5, 10
	mul $t4, $t0, $t0
	mulo $t4, $t4, 5	#5t^2
	div $t4, $t4, 100
	add $t4, $t4, $t5	# $t4 = y(t)=Vy*t + 5*t^2
	
	la $s4, ($t4)

	PRINT_XY($t3, $t4)					
	la $a0, ($t3)
	la $a1, ($t4)
	jal get_address_from_xy
	sw $s1, ($v0)
	addi $t0, $t0, 1
	blt $s4, 256, loop	# check if not at the botton of the screen
	
	
	## save X0 and Y0 for the baunce function
#	mul $t6, $t0, $s2
#	div $t6, $t6, 10	# X0 = Vx*t

	la $t6, ($a0)	
	addi $t7, $zero, 256  	# Y0 = 256
	addi $t0, $zero, 0
	
#	mul $s2, $s2, $s5
#	div $s2, $s2, 100	# new $s2 value -> loss of $s5 % speed
#	mul $s3, $s3, $s5
#	div $s3, $s3, 100	# new $s3 value -> loss of $s5 % speed 
bounce:
	PRINT_INT($t0)
	
	mul $t1, $s2, $s5
	mul $t2, $t1, $t0
	div $t1, $t2, 1000	# Vx*L*t
	add $a0, $t6, $t1
	## x(t) = X0 + Vx*L*t
	
	mul $t1, $t0, $t0
	div $t1, $t1, 100	
	# $t1 = gt^2
	mul $t2, $t0, $s3,	# Vy * 10t(/10)
	mul $t2, $t2, $s5	
	div $t2, $t2, 100	# percantages
	## $t2 = (Vy + 10t)*L)
	sub $t1, $t1, $t2
	add $a1, $t7, $t1
	## y(t) = Y0 - (Vy+10t)*L + gt^2	
	
	la $s4, ($a0)
	
	jal get_address_from_xy
	sw $s1, ($v0)
	PRINT_XY($s4, $a1)
	addi $t0, $t0, 1
	blt $a1, 512, bounce
	

	
#	bne $t0, 200, loop		
	END
# @params:
# $s0 -> address of bmp
# $a0 -> x-coordinate
# $a1 -> y-coordinate
# retval:
# $v0 -> address of given cell
get_address_from_xy:
	sll $t1,$a0,2	# scale x values to bytes (4 bytes per pixel)
	sll $t2,$a1,11	# scale y values to bytes (512*4 bytes per display row)
	addu $t2,$t2,$s0
	addu $v0,$t2,$t1
	jr $ra

