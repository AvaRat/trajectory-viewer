.include "functions.asm"
.include "basics.asm"

.data
header: .ascii "BM"
bmp_size: .word 32
offset: .word 0
size_of_header: .word 12
bmp_width: .half 1020
bmp_height: .half -512
color_planes: .half 1
bits_per_pixel: .half 1
white_pixel: .word 255

	
.macro save(%x, %n)
	li $v0, 15
	move $a0, $s7
	la $a1, %x
	li $a2, %n
	syscall	
.end_macro


.text
	open_file($s7)
	
	FILE_TEST($s7)	
		
save_to_file:
	save(header, 2)
	save(bmp_size, 8)
	save(offset, 4)
	### DIB header	
	save(size_of_header, 4)
	save(bmp_width, 2)
	save(bmp_height, 2)
	save(color_planes, 2)
	save(bits_per_pixel, 2)
	
	addi $t1, $zero, 0
loop:	
	save(white_pixel, 1)
	
	addi $t1, $t1, 1
	blt $t1, 524288, loop
	
	FILE_TEST($v0)



	
	li $v0, 16
	move $a0, $s7
	syscall
	END
	
