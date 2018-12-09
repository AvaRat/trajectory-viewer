.include "functions.asm"
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
	draw_until_hit
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
	
