.data
	# A: .word 9999999
	Message: .asciiz "Enter an integer :"
	Alert: .asciiz "Data cannot be parsed !"
       Decimal: .asciiz "Decimal     : "
	Binary: .asciiz "Binary      : "
   Hexadecimal: .asciiz "Hexadecimal : "
	
	
.text

# initialize
	# la $v0, A	# store address of A into $v0
	# lw $t6, 0($v0)	# store the value of A into $t6
	
	add $s0, $sp, $zero	# store the starting address of stack
	li $t1, -1		# status -1
	li $t2, -2		# status 2
	
	li $v0, 51		
	la $a0, Message
	syscall			# display the dialog for inputting an integer
	
	
	add $t6, $a0, $zero	# store value of the integer read in $t6 
	add $t7, $t6, $zero	# and $t7
	
	beq $a1, $zero, initializeBinary	# if the status is 0 then t6 = integer read and jump to condition of loop
	nop
	beq $a1, $t1, alert		# if the status is -1 then go to Alert
	nop				
	beq $a1, $t2, endProgram	# if the status is -2 then go to End
	nop
	
# when data cannot be parsed
alert:
	li $v0, 4
	la $a0, Alert
	
	beq $zero, $zero, endProgram	# go to End
	syscall				# display dialog of alert
	
initializeBinary:
	li $v0, 4
	la $a0, Decimal
	syscall
	
	li $v0, 1 # service 1 is print integer
	add $a0, $0, $t6 # the interger to be printed is 0x307
	syscall
	
	li $v0, 11 	
	addi $a0, $0, 0xA
	syscall	
	
	li $v0, 4
	la $a0, Binary
	syscall
	
	beq $0, $0, conditionBinary
		
# condition of loop : check whether or not the number is zero
conditionBinary:
	bne $t6, $zero, calculateBinary	# if the number is not zero (be able to shift)
	nop
	beq $t6, $zero, loopPrintBinary	# if the number is zero (cannot shift anymore)
	nop
	
# start	loop of calculating each bit of the number
calculateBinary:	
	andi $a0, $t6, 1	# get the last bit of the number
	sw   $a0, 0($sp)	# store it into the stack
	addi $sp, $sp, 4	# adjust the stack pointer
	beq  $zero, $zero, conditionBinary	# go back to the condition
	srl  $t6, $t6, 1	# shift right the number one bit
				
# finish when A = 0		
loopPrintBinary: 
	bne $sp, $s0, printBinary	# if the current pointer of the stack is not the starting address then go to Print
	nop
	beq $sp, $s0, initializeHexa	# otherwise, go to End
	nop
	
# start priting out each bit
printBinary:	
	addi $sp, $sp, -4		# adjust the pointer of the stack
	lw   $a0, 0($sp)		# load the value of the current pointer
	li $v0, 1			
	beq $zero, $zero, loopPrintBinary # go back to the condition of the printing loop
	syscall				# print out the bit
	
	
#-----------------------------------------------------------------------------------------------------------------------------	


initializeHexa:
	add $t6, $t7, $zero	# recover the integer read from keyboard
	add $s0, $sp, $zero	# store the starting address of stack
	
	li $v0, 11 	
	addi $a0, $0, 0xA
	syscall	
	
	li $v0, 4
	la $a0, Hexadecimal
	syscall
	
	beq $zero, $zero, conditionHexa
	nop
	
# condition of loop : check whether or not the number is zero
conditionHexa:
	bne $t6, $zero, calculateHexa	# if the number is not zero (be able to shift)
	nop
	beq $t6, $zero, loopPrintHexa	# if the number is zero (cannot shift anymore)
	nop
	
# start	loop of calculating each bit of the number
calculateHexa:	
	andi $a0, $t6, 0xf	# get the last bit of the number
	sw   $a0, 0($sp)	# store it into the stack
	addi $sp, $sp, 4	# adjust the stack pointer
	beq  $zero, $zero, conditionHexa	# go back to the condition
	srl  $t6, $t6, 4	# shift right the number one bit
				
# finish when A = 0		
loopPrintHexa: 
	bne $sp, $s0, printHexa	# if the current pointer of the stack is not the starting address then go to Print
	nop
	beq $sp, $s0, endProgram	# otherwise, go to End
	nop
	
# start priting out each bit
printHexa:	
	addi $sp, $sp, -4		# adjust the pointer of the stack
	lw   $a0, 0($sp)		# load the value of the current pointer
	li $v0, 1			
	beq $zero, $zero, loopPrintHexa # go back to the condition of the printing loop
	syscall				# print out the bit


endProgram:


	


	
