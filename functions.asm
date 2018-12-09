.data
filename: .asciiz "trajectory.bmp"
header_field: .ascii "BM"
image_size: .word 4718666
offset: .word 74
DIB_header_size: .word 40
image_width: .word 1024
image_height: .word 512
color_planes: .half 1
bits_per_pixel: .half 24
compression_method: .word 0
raw_image_size: .word 4718592
horizontal_res: .word 
vertical_res: .word 
  

.text

.macro open_file(%f)
	li $v0, 13
	la $a0, filename
	li $a1, 1
	li $a2, 0
	syscall
	move %f, $v0
.end_macro

.macro create_header(%f)


.end_macro

.macro save_2_bytes(%d, %f)
	





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
.macro draw_until_hit

	
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
	bge $t2, 512, hit
	bge $t1, 1024, hard_stop
		
	get_address_from_xy
	sw $s1, ($v0)

	b drawing_loop
hit:		
.end_macro	
				
# @params:
# $s0 -> address of bmp
# $a0 -> x-coordinate
# $a1 -> y-coordinate
# retval:
# $v0 -> address of given cell
.macro get_address_from_xy
	sll $t6,$a0,2	# scale x values to bytes (4 bytes per pixel)
	sll $t7,$a1,12	# scale y values to bytes (512*4 bytes per display row)
	addu $t7,$t7,$s0
	addu $v0,$t7,$t6
.end_macro
