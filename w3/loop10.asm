.data
	i: .word 1
	S: .word 0
	
.text
	
START:
	la $v0, i
	la $v1, S
	lw $t6, 0($v0)
	lw $t7, 0($v1)
	
LOOP:
	add $t7, $t7, $t6
	addi $t6, $t6, 1
	sw $t6, 0($v0)
	sw $t7, 0($v1)
	slti $t0, $t6, 10
	bne $t0, $zero, LOOP
	nop
	

	
	 