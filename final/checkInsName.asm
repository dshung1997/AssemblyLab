.eqv SPACE 0x20
.eqv COMMA 0x2c
.eqv $100 0x24
.eqv _a 0x60
.eqv _z 0x7b
.eqv _0 0x2f
.eqv _9 0x3a
.eqv NULL 0x00
.eqv _ex 0x21
.eqv _open 0x28
.eqv _close 0x29

.data
	test: .asciiz "add "
	test1: .asciiz "12($v1)"
	
	opcodeOK: .asciiz "Opcode is OK !"
	param1OK: .asciiz "Param1 is OK !"
	param2OK: .asciiz "Param2 is OK !"
	param3OK: .asciiz "Param3 is OK !"
	
	opcodeError: .asciiz "Opcode is invalid !"
	param1Error: .asciiz "Param1 is invalid !"
	param2Error: .asciiz "Param2 is invalid !"
	param3Error: .asciiz "Param3 is invalid !"
	
	_ins: .asciiz 	"add 111 1",
			"sub 111 1",
			"addi 112 1",
			"addu 111 1",
			"subu 111 1",
			"addiu 112 1",
			"mfc0 110 1",
			"mult 110 1",
			"multu 110 1",
			"div 110 1",
			"divu 110 1",
			"mfhi 100 1",
			"mflo 100 1",
			"and 111 1",
			"or 111 1",
			"andi 112 1",
			"ori 112 1",
			"sll 112 1",
			"srl 112 1",
			"lw 130 1",
			"sw 130 1",
			"lbu 130 1",
			"sb 130 1",
			"lui 120 1",
			"beq 112 2",
			"bne 112 2",
			"slt 111 1",
			"slti 112 1",
			"sltu 111 1",
			"sltiu 112 1",
			"j 400 2",
			"jal 400 2",
			"jr 100 2",
			"!"
	_reg: .asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra", "$0", "$1", "$2", "$3", "$4", "$5", "$6", "$7", "$8", "$9", "$10", "$11", "$12", "$13", "$14", "$15", "$16", "$17", "$18", "$19", "$20", "$21", "$22", "$23", "$24", "$25", "$26", "$27", "$28", "$29", "$30", "$31", "!"
	
.text
	la $t0, test1
	la $t1, param3OK
	la $t2, param3Error
	
	
	# $t0 dia chi
	# $t1 OK
	# $t2 Error
	jal checkAddressParam
	nop
	
	j end
	nop
###### check String in List ########################################################################################################################################	

# $t0 & $t8 - dia chi cua string can check
# $t1 - dia chi cua list 
# $t2 - return
# $t5 - Ok message
# $t6 - Error message

checkStringInList:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	add $t8, $t0, $0

checkCharString:
	lb $t3, 0($t0)	
	lb $t4, 0($t1)	
	
	beq $t4, _ex, stringInvalid # neu list den ! -> invalids
	nop 
	beq $t3, $t4, sameCharString # neu 2 cai bang nhau
	nop
	beq $t3, NULL, checkNULL
	nop
	
	j getNext
	nop
	
checkNULL:
	beq $t4, SPACE, validString
	nop
	
	beq $t4, NULL, validString
	nop
	
	j getNext
	nop
	
validString:
	li $t2, 1
	add $t9, $t5, $0
	jal displayMessage
	nop
	j return_checkStringInList
	nop	
	
sameCharString:
	beq $t4, NULL, validString
	nop
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j checkCharString
	nop
	
getNext:
	add $t0, $t8, $0
	jal ignoreChar
	nop
	addi $t1, $t1, 1 # ignore \0
	j checkCharString
	nop

stringInvalid:
	li $t2, 0
	add $t9, $t6, $0
	jal displayMessage
	nop
	j end
	nop
	
return_checkStringInList:
	addi $sp, $sp, +4
	lw $ra, 0($sp)
	jr $ra
	nop


###### end | check String in list ########################################################################################################################################	


####### ignoreChar ##################################################################################################################################
# $t1 la dia chi cua string 

# giu gia tri hien tai
ignoreChar:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
isNULL:
	lb $s1, 0($t1)
	
	beq $s1, NULL, return_ignoreChar
	nop
	
	j notNULL_next
	nop
	
notNULL_next:
	addi $t1, $t1, 1
	j isNULL
	nop

return_ignoreChar:
	addi $sp, $sp, 4
	lw $ra, 0($sp)	
	jr $ra
	nop

##### end | trimSpace ##################################################################################################################################	





##### check Address Param ##################################################################################################################################	
# $t0 dia chi
# $t1 OK
# $t2 Error

# $t3 - get byte from $t0
# $t5 - 0
# $t6 - 9


checkAddressParam:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	li $t5, _0
	li $t6, _9

checkNumberPart:
	lb $t3, 0($t0)
		
	slt $t7, $t5, $t3 # a <= $t2
	slt $t8, $t3, $t6 # $t2 <= z
	
	and $t7, $t7, $t8
	beq $t7, 1, nextCharNumberPart1
	nop
	
	beq $t3, _open, checkAddressPart
	nop
	
	bne $t7, 1, invalidAddress
	nop 

nextCharNumberPart1:
	addi $t0, $t0, 1
	j checkNumberPart
	nop

checkAddressPart:
	addi $t0, $t0, 1 # ignore the open (
	add $t4, $0, $t0
	j getClose
	nop
	
getClose:
	lb $t3, 0($t4)	
	bne $t3, 0, getCloseNext
	nop
	beq $t3, 0, checkClose
	nop
	
getCloseNext:
	addi $t4, $t4, 1
		
	j getClose
	nop
	
checkClose:
	addi $t4, $t4, -1
	lb $t3, 0($t4)
	
	beq $t3, _close, checkAddressInside
	nop
	bne $t3, _close, invalidAddress
	
checkAddressInside:
	sb $0, 0($t4)
	# $t0 & $t8 - dia chi cua string can check
	# $t1 - dia chi cua list 
	# $t2 - return
	# $t5 - Ok message
	# $t6 - Error message
	add $t0, $t0, $0
	addi $t5, $t1, 0
	addi $t6, $t2, 0
	la $t1, _reg
	
	jal checkStringInList
	nop
	
	j return_checkAddressParam
	nop
	

invalidAddress:
	add $t9, $0, $t2
	jal displayMessage
	nop
	j end
	nop

return_checkAddressParam:
	addi $sp, $sp, +4
	lw $ra, 0($sp)
	jr $ra
	

##### end | check Address Param  ##################################################################################################################################	






displayMessage:
	li $v0, 4
	add $a0, $0, $t9
	syscall
	jr $ra
	nop

end:
	nop
