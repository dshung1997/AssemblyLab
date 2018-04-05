.data
	# A: .word 9999999
	Message: .asciiz "Enter a non-negative integer :"
	Alert: .asciiz "Data cannot be parsed !"
       Decimal: .asciiz "Decimal     : "
	Binary: .asciiz "Binary      : "
   Hexadecimal: .asciiz "Hexadecimal : "
	
	
.text

# initialize
	# la $v0, A	# store address of A into $v0
	# lw $t6, 0($v0)	# store the value of A into $t6
	
	add $s7, $sp, $zero	# store the starting address of stack
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
	
	
zeroinput:
	li $v0, 4
	la $a0, Decimal
	syscall
	
	li $v0, 1
	li $a0, 0
	syscall
	
	li $v0, 11 		# print a new line
	addi $a0, $0, 0xA
	syscall	
	
	li $v0, 4
	la $a0, Binary
	syscall
	
	li $v0, 1
	li $a0, 0
	syscall
	
	li $v0, 11 		# print a new line
	addi $a0, $0, 0xA
	syscall	
	
	li $v0, 4
	la $a0, Hexadecimal
	syscall
	
	li $v0, 1
	li $a0, 0
	syscall
	
	li $v0, 11 		# print a new line
	addi $a0, $0, 0xA
	syscall	
	
	beq $0, $0, endProgram
	
initializeBinary:

	beq $t6, $0, zeroinput
	nop
	
	slt $t9, $t6, $0
	addi $t8, $0, 1
	beq $t9, $t8, alert
	nop

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
	nop
		
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
	bne $sp, $s7, printBinary	# if the current pointer of the stack is not the starting address then go to Print
	nop
	beq $sp, $s7, initializeHexa	# otherwise, go to Hexa section
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
	add $s7, $sp, $zero	# store the starting address of stack
	
	addi $s0, $0, 10	# store 10 in $s0
	addi $s1, $0, 11	# store 11 in $s1
	addi $s2, $0, 12	# store 12 in $s2
	addi $s3, $0, 13	# store 13 in $s3
	addi $s4, $0, 14	# store 14 in $s4
	addi $s5, $0, 15	# store 15 in $s5
	
	li $v0, 11 		# print a new line
	addi $a0, $0, 0xA
	syscall	
	
	li $v0, 4		# print Hexa :...
	la $a0, Hexadecimal
	syscall
	
	beq $zero, $zero, conditionHexa	# jump to condition of Hexa section
	nop
	
# condition of loop : check whether or not the number is zero
conditionHexa:
	bne $t6, $zero, calculateHexa	# if the number is not zero (be able to shift)
	nop
	beq $t6, $zero, loopPrintHexa	# if the number is zero (cannot shift anymore)
	nop
	
# start	loop of calculating each bit of the number
calculateHexa:	
	andi $a0, $t6, 0xf	# get the last 4 bits of the number
	sw   $a0, 0($sp)	# store it into the stack
	addi $sp, $sp, 4	# adjust the stack pointer
	beq  $zero, $zero, conditionHexa	# go back to the condition
	srl  $t6, $t6, 4	# shift right the number 4 bits
				
# finish when A = 0		
loopPrintHexa: 
	bne $sp, $s7, printHexa	# if the current pointer of the stack is not the starting address then go to Print
	nop
	beq $sp, $s7, endProgram	# otherwise, go to End
	nop
	
# start priting out each bit
printHexa:	
	addi $sp, $sp, -4		# adjust the pointer of the stack
	lw   $a0, 0($sp)		# load the value of the current pointer
	slt $t3, $a0, $s0		# t3 = 0 if $a0 (the current number) < $s0 (10) 
	beq $t3, $0, convert10		# jump to convert10 if t3 == 0 (the current number >= 10)
	li $v0, 1			# print a decimal integer
	beq $zero, $zero, loopPrintHexa # go back to the condition of the printing loop
	syscall				# print out the number


#--------------------------------------------------------------------------------------------------------------------

# function to convert 10 to A, 11 to B, ...
convert10:
	li $v0, 11			# print a character
	
	add $a1, $a0, $0		# store the current number in $a1 - because we use $a0 below
	
	beq $a1, $s0, print1x		# if a1 = 10, jump to print1x
	li $a0, 'A'			# set a0 to 'A'
	beq $a1, $s1, print1x		# if a1 = 11,...
	li $a0, 'B'
	beq $a1, $s2, print1x		# if a1 = 12,...
	li $a0, 'C'
	beq $a1, $s3, print1x		# if a1 = 13,...
	li $a0, 'D'
	beq $a1, $s4, print1x		# if a1 = 14,...
	li $a0, 'E'
	beq $a1, $s5, print1x		# if a1 = 15,...
	li $a0, 'F'
	
print1x:
	beq $zero, $zero, loopPrintHexa	# go back to the loop print hexa
	syscall				# at the same time, print out the character
	
endProgram:
	# j endProgram
	# nop
	 li $v0, 10
	 syscall


	


	
