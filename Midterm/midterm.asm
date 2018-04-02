.text
	li $a1, 0x20
	li $a2, 0x22
	li $a3, 0x18
		
	li $t1, 5
	li $t2, 2

	la $s1, func
	lw $s2, 0($s1)
	
	srl $s2, $s2, 6
	sll $s2, $s2, 6
	
	or $s2, $s2, $a2
	sw $s2, func2
	j func2
	nop
	
func:
	add $t0, $t1, $t2
	
func2:
	
	
	
	