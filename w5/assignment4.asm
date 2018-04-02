.data
	Ten: .asciiz "Hung"
	Ho: .asciiz "Doan"
	
.text
	li $v0, 59
	la $a0, Ho
	la $a1, Ten
	
	syscall