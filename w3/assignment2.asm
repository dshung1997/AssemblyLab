#Laboratory 3, Home Assigment 2

.data
	A: .word 0, 1, 2, 3, 4
	i: .word 0
	n: .word 4

.text
	la $a1, i
	lw $s1, 0($a1)
	
	la $a3, n
	lw $s3, 0($a3)
	la $s2, A
	
	addi $s4, $zero, 1
	
	# s5 = sum
	
loop:
	add $s1,$s1,$s4 #i=i+step, step = 1
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$s2 #t1 store the address of A[i]
	lw $t0,0($t1) #load value of A[i] in $t0
	add $s5,$s5,$t0 #sum=sum+A[i]
	bne $s1,$s3, loop #if i != n, goto loop
	nop
