.include "basics.asm"
.data
filename: .asciiz "trajectory.bmp"
header_field: .ascii "BM"
image_size: .word 400054
default_0: .word 0
offset: .word 54
DIB_header_size: .word 40
image_width: .word 512
image_height: .word -256
color_planes: .half 1
bits_per_pixel: .half 24
compression_method: .word 0
raw_image_size: .word 393216
horizontal_res: .word 0
vertical_res: .word 0
colors_n: .word 0
important_col: .word 0

black: .byte 0
white: .byte 255

.text

.macro open_file(%f)
	li $v0, 13
	la $a0, filename
	li $a1, 1
	li $a2, 0
	syscall
	move %f, $v0
.end_macro

.macro close_file(%f)
	move $a0, %f
	li $v0, 16
	syscall
.end_macro

# %a -> output buffer
# %f -> file descryptor
.macro save_buffer(%a, %f)
	move $a0, %f
	move $a1, %a
	lw $a2, raw_image_size
	li $v0, 15
	syscall
.end_macro	
	

.macro allocate_memory_for_image(%x)
	lw $a0, raw_image_size
	li $v0, 9
	syscall
	move %x, $v0
.end_macro

.macro create_header(%f)
	la $t1,  header_field
	save_half($t1, %f)
	la $t1, image_size
	save_word($t1, %f)	
	la $t1 default_0	
	save_word($t1, %f)
	la $t1, offset
	save_word($t1, %f)
## DIB header	
	la $t1, DIB_header_size
	save_word($t1, %f)	
	la $t1, image_width
	save_word($t1, %f)	
	la $t1, image_height
	save_word($t1, %f)	
	la $t1, color_planes
	save_half($t1, %f)	
	la $t1, bits_per_pixel
	save_half($t1, %f)		
	la $t1, compression_method
	save_word($t1, %f)
	la $t1, raw_image_size
	save_word($t1, %f)
	
	la $t1, horizontal_res
	save_word($t1, %f)
	la $t1, vertical_res
	save_word($t1, %f)
	la $t1, colors_n
	save_word($t1, %f)
	la $t1, important_col
	save_word($t1, %f)
	
	
.end_macro

# allocated memory in %x
.macro	make_image_white(%x)
	li $t3, 255	# white
	lw $t4,	raw_image_size
	
	addiu $t1, $zero, 0	# byte counter
	move $t2, %x
loop:
	sb $t3, ($t2)
	addi $t2, $t2, 1
	addi $t1, $t1, 1
	blt  $t1, $t4, loop
.end_macro	
	

.macro save_half(%h, %f)
	move $a0, %f
	la $a1, (%h)
	li $a2, 2
	li $v0, 15
	syscall	
	FILE_TEST($v0)
.end_macro
.macro save_word(%w, %f)
	move $a0, %f
	la $a1, (%w)
	li $a2, 4
	li $v0, 15
	syscall	
	FILE_TEST($v0)
.end_macro




# @params:
# $a0 -> X(0)-coordinate
# $a1 -> Y(0)-coordinate
# $a2 -> Vx(0)	=	 speed[x] at the beginning
# $a3 -> Vy(0)	=	 speed[y] at the beginning
##
# retval:
# $t1 -> X(0)- last x coordinate
# $t2 -> Y(0)-last x coordinate
# $s1 -> RGB value
# $s2 -> Vx(0)	=	 speed[x] at the end
# $s3 -> Vy(0)	=	 speed[y] at the end
# void -> it draws a function until it reaches one of the edges
# dt = 0.1s
# (x,y) = (10,10) equals (1m,1m)
.macro draw_until_hit

	lb $s1, black
	move $s2, $a2	# $s2 -> Vx = dx
	move $s3, $a3	# $s3 -> Vy
	
	move $t1, $a0	#x
	move $t2, $a1	#y
		
drawing_loop:	

	addi $s3, $s3, 1	# dVy = 0.1m/s		
	
	add $t1, $t1, $s2	# x = x + dx	
	add $t2, $t2, $s3	# y = y + dy			
	PRINT_XY($t1, $t2)
	
	move $a0, $t1
	move $a1, $t2
	bge $t2, 256, hit
	bge $t1, 512, finish
		
	get_address_from_xy
	move $t3, $v0
	addi $t3, $t3, -4
	sb $s1, ($t3)
	addi $t3, $t3, 1
	sb $s1, ($t3)
	addi $t3, $t3, 1
	sb $s1, ($t3)

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
	mul $t6,$a0,3	# scale x values to bytes (3 bytes per pixel)
	#sll $t7,$a1,10	# scale y values to bytes (512*4 bytes per display row)
	mul $t7, $a1, 1536
	addu $t7,$t7,$s0
	addu $v0,$t7,$t6
.end_macro
