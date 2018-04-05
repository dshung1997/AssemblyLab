.text
main:



printSpace:
	li $v0, 11
	li $a0, ' '
	syscall
	
printAsterisk:
	li $v0, 11
	li $a0, '*'
	syscall
	syscall
	syscall
	syscall
	
printNewLine:
	li $v0, 11
	li $a0, 0xA
	syscall

