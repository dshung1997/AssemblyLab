.data
	A: .word 100
	
.text
	la $s0, A
	lw $s1, 0($s0)
	
	li $a0, 0xf
	
	and $a1, $s1, $a0
	
	