.data
	A: .word -1, 2, 3, -4, 5, -7, 3, -2
	n: .word 8
	i: .word 0
	
.text
	la $t5, A
	la $t6, n
	la $t7, i
	
	lw $s5, 0($t5)	#init : s5 = A[0]
	lw $s6, 0($t6)	#n
	lw $s7, 0($t7)	#i
	
	addi $s4, $zero, 1
	
loop:	
	slt $a1, $s1, $s6
	beq $a1, $zero, continue
	nop
	
	add $t1,$s1,$s1 #t1=2*s1
	add $t1,$t1,$t1 #t1=4*s1
	add $t1,$t1,$t5 #t1 store the address of A[i]
	
	lw $t4, 0($t1)
	
	slt $t2, $t4, $zero	#if A[i] < 0 then t2 = 1
	beq $t2, $zero, next	#if t2 = 0 ( != 1 ) => else 
	nop
	sub $t4, $zero, $t4	#t4= |t4| ( 0 - t4)
	
next:	
	slt $t3, $s5, $t4	#if s5 < t4 ( max < A[i] ) then t3 = 1
	beq $t3, $zero, subnext	#if t3 == 0
	nop
	add $s5, $t4, $zero	#then s5 = |A[i]|
	
subnext:	
	# bne $s1,$s3,loop #if i != n, goto loop
	add $s1,$s1,$s4 #i=i+step
	beq $zero, $zero, loop
	nop
	
else:
	
	
continue:	