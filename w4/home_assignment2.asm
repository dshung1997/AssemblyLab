#Laboratory Exercise 4, Home Assignment 2
.text
	li $s0, 0x12345678 #load test value for these function
	andi $t0, $s0, 0xff #Extract the LSB of $s0
	andi $t1, $s0, 0x0400 #Extract bit 10 of $s0
	andi $t2, $s0, 0xff000000
	
	xor $s0, $s0, $t0	# clear LSB of $s0
	
	li $v1, 0x44
	or $s0, $s0, $v1 	# set LSB of $s0 (bits 7 to 0 are set to 1)
	
	andi $s0, 1		# clear $s0
	