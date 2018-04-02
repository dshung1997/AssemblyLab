#Laboratory Exercise 3, Home Assignment 1
start:
	slt $t0,$s2,$s1 # j<i
	
	# slt slt $t0, $s1, $s2     # i < j
	
	# sub $s0, $s1, $s2	    # i >= j
	# slt $t0, $s0, $zero
	# beq $t0, $zero, dosth
	
	
	# add $s0, $s1, $s2		# i + j <= 0
	# slt $t0, $zero, $s0
	# beq $t0, $zero, dosth
	
	# add $s0, $s1, $s2		# i + j > m + n
	# add $s1, m, n
	# slt $t0, $s1, $s0
	# bne $t0, $zero, dosth
	
	
	
	bne $t0,$zero,else # branch to else if j<i
	addi $t1,$t1,1 # then part: x=x+1
	addi $t3,$zero,1 # z=1
	j endif # skip “else” part
else:
	addi $t2,$t2,-1 # begin else part: y=y-1
	add $t3,$t3,$t3 # z=2*z
endif:
