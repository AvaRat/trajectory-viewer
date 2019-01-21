# Read integer A from user and store it into a register
# Display the integer in binary
# Display the integer in Hex
# set Register $a0 to contain only bits 12,13,14,15 of $a0
# Display the integer in binary contained in $a0
# Display the integer in hex contained in $a0

    .data
binaryInput:    .asciiz "Here is  "
binaryInput_2: .asciiz "  in binary: "
nl:         .asciiz     "\n"
hexInput:   .asciiz     "Here is the input in hexadecimal: "
binaryOutput:   .asciiz "Here is the output in binary: "
hexOutput:  .asciiz     "Here is the output in hexadecimal: "
hexDigit:   .asciiz     "0123456789ABCDEF"
obuf:       .space      100
obufe:

.text

#add %r = %x + %y    
.macro MY_ADDI(%r, %x, %y)
	sub $sp, $sp, 4
	sw $t1, ($sp)
	addi $t1, $zero, %y
	sll $t1, $t1, 10
	add %r, %x, $t1
	lw $t1, ($sp)
	addi $sp, $sp, 4
.end_macro
# subtract %r = %x - %y
.macro MY_SUB(%r, %x, %y)
	sub $sp, $sp, 4
	sw $t1, ($sp)
	addi $t1, $zero, %y
	sll $t1, $t1, 10
	sub %r, %x, $t1
	lw $t1, ($sp)
	addi $sp, $sp, 4
.end_macro
	


# prtbin -- print in binary
#
# arguments:
#   %x -- number to print
#   a0 -- output string          
.macro PRINT_BINARY(%x)  
prtbin:
	
	sub $sp, $sp, 40
	sw %x, 36($sp)
	sw $s0, 32($sp)
	sw $a0, 28($sp)
	sw $a1, 24($sp)
	sw $a2, 20($sp)	
	sw $t7, 16($sp)
	sw $t6, 12($sp)
	sw $t5, 8($sp)
	sw $t0, 4($sp)
	sw $v0, 0($sp)
	
	
    move $s0, %x
    la $a0, binaryInput
    li $a1, 32
    li      $a2,1                   # bit width of number base digit

# prtany -- print in given number base
#
# arguments:
#   a0 -- output string
#   a1 -- number of bits to output
#   a2 -- bit width of number base digit
#   s0 -- number to print
#
# registers:
#   t0 -- current digit value
#   t5 -- current remaining number value
#   t6 -- output pointer
#   t7 -- mask for digit
prtany:
    li      $t7,1
    sllv    $t7,$t7,$a2             # get mask + 1
    subu    $t7,$t7,1               # get mask for digit

    la      $t6,obufe               # point one past end of buffer
    subu    $t6,$t6,1               # point to last char in buffer
    sb      $zero,0($t6)            # store string EOS

    move    $t5,$s0                 # get number

prtany_loop:
    and     $t0,$t5,$t7             # isolate digit
    lb      $t0,hexDigit($t0)       # get ascii digit

    subu    $t6,$t6,1               # move output pointer one left
    sb      $t0,0($t6)              # store into output buffer

    srlv    $t5,$t5,$a2             # slide next number digit into lower bits
    sub     $a1,$a1,$a2             # bump down remaining bit count
    bgtz    $a1,prtany_loop         # more to do? if yes, loop

    # output string_1
    li      $v0,4
    la $a0, binaryInput
    syscall
    
    #output integer in decimal
    li $v0, 1
    move $a0, $s0
    syscall


        # output string_2
    li      $v0,4
    la $a0, binaryInput_2
    syscall

    # output the number
    move    $a0,$t6                 # point to ascii digit string start
    syscall
    
    # output newline
    la      $a0,nl
    syscall
    

	
	sw %x, 36($sp)
	lw $s0, 32($sp)
	lw $a0, 28($sp)
	lw $a1, 24($sp)
	lw $a2, 20($sp)	
	lw $t7, 16($sp)
	lw $t6, 12($sp)
	lw $t5, 8($sp)
	lw $t0, 4($sp)
	lw $v0, 0($sp)
	addi $sp, $sp, 40
	
.end_macro
