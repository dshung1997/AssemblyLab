#Laboratory Exercise 4, Home Assignment 1
.text
	li $s1,  99999999999999
	li $s2,  99999999999999
start:
	li $t0, 0 #No Overflow is default status
	addu $s3, $s1, $s2 # s3 = s1 + s2s
	xor $t1, $s1, $s2 #Test if $s1 and $s2 have the same sign
	bltz $t1, EXIT #If not, exit
	slt $t2, $s3, $s1
	bltz $s1, NEGATIVE #Test if $s1 and $s2 is negative?
	nop
	beq $t2, $zero, EXIT #s1 and $s2 are positive
	nop
		# if $s3 > $s1 then the result is not overflow
	j OVERFLOW
		
NEGATIVE:
	bne $t2, $zero, EXIT #s1 and $s2 are negative
	nop
		# if $s3 < $s1 then the result is not overflow
		
OVERFLOW:
	li $t0, 1 #the result is overflow
EXIT: