 .include "print_in_binary.asm"
    .data
userInput:  .asciiz     "Please enter your integer: "
    
    .text
    

  
    .globl  main
main:
    # ask end-user to submit an integer value
    li      $v0,4
    la      $a0,userInput
    syscall

    # read user-input
    li      $v0,5
    syscall
    move    $s0,$v0
    
    sll $s0, $s0, 10
    PRINT_BINARY($s0)
 #   mul $s0, $s0, 287	#mnozenie przez 2
#    MY_ADDI($s0, $s0, 89)	#dodawanie 89   
 #   div $s0, $s0, 101	#podzielic na 100
 #   PRINT_BINARY($s0)
 #   mul $s0, $s0, 105
    PRINT_BINARY($s0)
#    mul $s0, $s0, 1536
 #   PRINT_BINARY($s0)
	srl $s0, $s0, 10
	PRINT_BINARY($s0)
    # exit the program
    li      $v0,10
    syscall
  
    