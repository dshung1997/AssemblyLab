.text # Vung lenh, chua cac lenh hop ngu
addi $t1, $0, 1
addi $t2, $0, 1

addi $t3, $0, 2
addi $s1, $0, 1
addi $s2, $0, 19

srl $a1, $s2, 1
sw $a2, 0($t7)

condition:
	beq $s2, $t3, end
	nop
	bne $s2, $t3, cal
	
cal:
	addi $t3, $t3, 1
	and $t4, $t3, 1
	beq $t4, $s1, odd
	nop
	j even
	nop
		
odd:
	add $t1, $t1, $t2
	add $a0, $0, $t1
	j condition
	
even:
	add $t2, $t1, $t2
	add $a0, $0, $t2
	j condition
	
end:
	
	

	
	
