.data
	A: .word 100
	
.text
li $v0, 1 # service 1 is print integer
li $a0, 0 # the interger to be printed is 0x307
syscall
	
