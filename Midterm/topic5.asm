.data
	# A: .word 9999999
	Message: .asciiz "Enter an integer :"
	Alert: .asciiz "Data cannot be parsed !"
	
.text

# initialize
	# la $v0, A	# store address of A into $v0
	# lw $v1, 0($v0)	# store the value of A into $v1
	
	add $s0, $sp, $zero	# store the starting address of stack
	li $t1, -1		# status -1
	li $t2, -2		# status 2
	
	li $v0, 51		
	la $a0, Message
	syscall			# display the dialog for inputting an integer
	
	
	
	beq $a1, $zero, condition	# if the status is 0
	add $v1, $a0, $zero		# then v1 = integer read and jump to condition of loop
	beq $a1, $t1, alert		# if the status is -1 then go to Alert
	nop				
	beq $a1, $t2, endProgram	# if the status is -2 then go to End
	nop
	
# data cannot be parsed
alert:
	li $v0, 4
	la $a0, Alert
	
	beq $zero, $zero, endProgram	# go to End
	syscall				# display dialog of alert
	
# condition of loop : check whether or not the number is zero
condition:
	bne $v1, $zero, startLoopBits	# if the number is not zero (be able to shift)
	nop
	beq $v1, $zero, finishLoopBits	# # if the number is zero (cannot shift anymore)
	nop
	
# start	loop of calculating each bit of the number
startLoopBits:	
	andi $a0, $v1, 1	# get the last bit of the number
	sw   $a0, 0($sp)	# store it into the stack
	addi $sp, $sp, 4	# adjust the stack pointer
	beq  $zero, $zero, condition	# go back to the condition
	srl  $v1, $v1, 1	# shift right the number one bit
				
# finish when A = 0		
finishLoopBits: 
	bne $sp, $s0, startLoopPrint	# if the current pointer of the stack is not the starting address then go to Print
	nop
	beq $sp, $s0, endProgram	# otherwise, go to End
	nop
	
# start priting out each bit
startLoopPrint:	
	addi $sp, $sp, -4		# adjust the pointer of the stack
	lw   $a0, 0($sp)		# load the value of the current pointer
	li $v0, 1			
	beq $zero, $zero, finishLoopBits # go back to the condition of the printing loop
	syscall				# print out the bit

endProgram:


	


	
