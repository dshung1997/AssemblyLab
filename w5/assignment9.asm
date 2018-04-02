li $v0, 11
li $a0, 'k'
syscall

li $v0, 12
syscall

.data
Message: .asciiz "Ban la SV Ky thuat May tinh?"
.text
li $v0, 50
la $a0, Message
syscall


.text
li $v0, 55
la $a0, Message
li $a1, 1
syscall