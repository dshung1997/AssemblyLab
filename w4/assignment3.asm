.text

#abs
	li $s1, -10
	bge $s1, $zero, NEXT
	nop
	sub $s1, $zero, $s1
		
NEXT:
	add $s0, $s1, $zero
	
	
#move
	li $s2, -10
	li $s3, 0
	or $s3, $s3, $s2
	
#not
	li $s4, 12
	li $s5, -1
	sub $s6, $s5, $s4
	
	not $s7, $s4
	
	