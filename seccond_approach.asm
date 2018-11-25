.include "basics.asm"
.text
	ASK_GET_Vx($s2)
	ASK_GET_Vy($s3)
#	ASK_GET_L($s5)
	
	li $s1, -1 #white color

	la $s0, frameBuffer	##!!! dont touch !!!##
	li $t0, 0	# set time to 0	
	
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	
	move $a2, $s2
	move $a3, $s3
# @params:
# $t0 -> time
# $a0 -> X(0)-coordinate
# $a1 -> Y(0)-coordinate
# $a2 -> Vx(0)	=	 speed[x] at the beginning
# $a3 -> Vy(0)	=	 speed[y] at the beginning
# retval:
# void -> it draws a function unless it reaches one of the edges
# dt = 0.1s
# (x,y) = (10,10) equals (1m,1m)
draw:
	
	move $s2, $a2	# $s2 -> Vx = dx
	move $s3, $a3	# $s3 -> Vy
	
	move $t1, $a0	#x
	move $t2, $a1	#y
	
	addi $t0, $zero, 0	# timer set to zero	
#	jal get_address_from_xy
#	sw $s1, ($v0) # draw (0,0)

loop:	

#	move $t2, $s3	# dy = dVy * dt	(dt = 1/10s)
	addi $s3, $s3, 1	# dVy = 0.1m/s		
	
	add $t1, $t1, $s2	# x = x + dx	
	add $t2, $t2, $s3	# y = y + dy			
	PRINT_XY($t1, $t2)
	
	move $a0, $t1
	move $a1, $t2	
	jal get_address_from_xy
	sw $s1, ($v0)
	addi $t0, $t0, 1	# timer incrementation	-> +0.1s !!!! unnecessarry !!!!
	blt $t2, 256, second_check
	END
second_check:
	bgt $t2, 0, loop			
	END		
				
# @params:
# $s0 -> address of bmp
# $a0 -> x-coordinate
# $a1 -> y-coordinate
# retval:
# $v0 -> address of given cell
get_address_from_xy:
	sll $t6,$a0,2	# scale x values to bytes (4 bytes per pixel)
	sll $t7,$a1,11	# scale y values to bytes (512*4 bytes per display row)
	addu $t7,$t7,$s0
	addu $v0,$t7,$t6
	jr $ra		
