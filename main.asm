.include "functions.asm"
.text
	ASK_GET_Vx($s2)	# fixed point number shifted 10 positions left
	ASK_GET_Vy($s3)	# fixed point number shifted 10 positions left
	ASK_GET_L($s5)	# fixed point number shifted 10 positions left
	
#	la $s0, frameBuffer		##!!! dont touch !!!## 
	allocate_memory_for_image($s0)
	make_image_white($s0)
	
	MY_ADDI($a0, $zero, 0)
	MY_ADDI($a1, $zero, 0)
	move $a2, $s2
	move $a3, $s3
	
	MY_ADDI($t1, $zero, 100)
	sub $s5, $t1, $s5	# set $s5 to be the percentage of speed remained after bounce
	
bounce:	
	draw_until_hit
#	BOUNCE_CHECK($t1, $t2, $s2, $s3)

	move $a0, $t1	# x(0) = last x
	MY_ADDI($a1, $zero, 256)
#	move $a1, $t2	# y(0) = last y
	
	mul $a2, $s2, $s5
	div $a2, $a2, 100	# new_Vx = Vx*L[%]
	
	mul $a3, $s3, $s5
	div $a3, $a3, 100	# new_Vy = Vy*L[%]
	sub $a3, $zero, $a3
	ble $a2, 1024, finish	# finish if Vx <= 1	-> 1024 after swich
	b bounce
finish:
	open_file($t0)
	create_header($t0)
	save_buffer($s0, $t0)
	close_file($t0)
	
	END	
	
