.include "basics.asm"
.text
	ASK_GET_Vx($s2)
	ASK_GET_Vy($s3)
	ASK_GET_L($s5)
	
	li $s1, -1 #white color		##!!! dont touch !!!##
	la $s0, frameBuffer		##!!! dont touch !!!## 
	
	addi $a0, $zero, 0
	addi $a1, $zero, 0	
	move $a2, $s2
	move $a3, $s3
	
	addi $t1, $zero, 100
	sub $s5, $t1, $s5	# set $s5 to be the percentage of speed remained after bounce
	
bounce:	
	jal draw_until_hit
#	BOUNCE_CHECK($t1, $t2, $s2, $s3)

	move $a0, $t1	# x(0) = last x
	addi $a1, $zero, 256
#	move $a1, $t2	# y(0) = last y
	
	mul $a2, $s2, $s5
	div $a2, $a2, 100	# new_Vx = Vx*L[%]
	
	mul $a3, $s3, $s5
	div $a3, $a3, 100	# new_Vy = Vy*L[%]
	sub $a3, $zero, $a3
	ble $a2, 1, hard_stop	
	b bounce
hard_stop:
	END	
	
# @params:
# $a0 -> X(0)-coordinate
# $a1 -> Y(0)-coordinate
# $a2 -> Vx(0)	=	 speed[x] at the beginning
# $a3 -> Vy(0)	=	 speed[y] at the beginning
##
# retval:
# $t1 -> X(0)- last x coordinate
# $t2 -> Y(0)-last x coordinate
# $s2 -> Vx(0)	=	 speed[x] at the end
# $s3 -> Vy(0)	=	 speed[y] at the end
# void -> it draws a function until it reaches one of the edges
# dt = 0.1s
# (x,y) = (10,10) equals (1m,1m)
draw_until_hit:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	move $s2, $a2	# $s2 -> Vx = dx
	move $s3, $a3	# $s3 -> Vy
	
	move $t1, $a0	#x
	move $t2, $a1	#y
		
drawing_loop:	

	addi $s3, $s3, 1	# dVy = 0.1m/s		
	
	add $t1, $t1, $s2	# x = x + dx	
	add $t2, $t2, $s3	# y = y + dy			
#	PRINT_XY($t1, $t2)
	
	move $a0, $t1
	move $a1, $t2	
	jal get_address_from_xy
	sw $s1, ($v0)
	bge $t2, 256, hit
	bge $t1, 512, hard_stop
	b drawing_loop
hit:		
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra		
				
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
# @params:
# $a0 -> integer to process
#retval:
# $v0 -> the opposite of given integer	

	
							
