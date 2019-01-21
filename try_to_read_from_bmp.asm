
.include "functions.asm"

.text
main:
	open_file($s7)
	FILE_TEST($s7)
	
	create_header($s7)
	allocate_memory_for_image($s6)
	
	li $s0, 255	# white
	lw $s2,	raw_image_size
	
	addiu $t1, $zero, 0	# byte counter
	move $t2, $s6
loop:
	sb $s0, ($t2)
	addi $t2, $t2, 1
	addi $t1, $t1, 1
	blt  $t1, $s2, loop
		
	save_buffer($s6, $s7)
	
	close_file($s7)
	
	END

	
11111111111110100000000000000000		-> -393216 deci
00000000000001100000000000000000		-> 393216 dec