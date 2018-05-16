.eqv SPACE 0x20
.eqv COMMA 0x2c
.eqv ENTER 0x0a
.eqv $100 0x24
.eqv _a 0x60
.eqv _z 0x7b
.eqv _0 0x2f
.eqv _9 0x3a
.eqv NULL 0x00
.eqv _ex 0x21
.eqv _open 0x28
.eqv _close 0x29

.eqv __0 0x30
.eqv __1 0x31
.eqv __2 0x32
.eqv __3 0x33
.eqv __4 0x34

.data
	# test: .asciiz "  add  $1, $42   ,         $s3  " # 31
	test: .space 40
	
	insName: .space 20
	insNameLength: .space 4
	insValid: .space 4
	
	param1: .space 20
	param1Length: .space 4
	
	param2: .space 20
	param2Length: .space 4
	
	param3: .space 20
	param3Length: .space 4
	
	cycle: .space 4
	
	
	# Messages
	inputMessage: .asciiz "Input the instruction (less than 40 chars)"
	
	errorMessage: .asciiz "Invalid instruction !"
	okMessage: .asciiz "Valid instruction !"
	
	opcodeOK: .asciiz "Opcode is OK !"
	param1OK: .asciiz "Param1 is OK !"
	param2OK: .asciiz "Param2 is OK !"
	param3OK: .asciiz "Param3 is OK !"
	
	opcodeError: .asciiz "Opcode is invalid !"
	param1Error: .asciiz "Param1 is invalid !"
	param2Error: .asciiz "Param2 is invalid !"
	param3Error: .asciiz "Param3 is invalid !"
	
	cycle1: .asciiz "This instruction takes 1 cycle !"
	cycle2: .asciiz "This instruction takes 2 cycles !"
	
	# instruction -  type of each param : 0 - dont have; 1 - register; 2 - immediate; 3 - imm($reg) ; 4 - label
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
	li $v0, 54
	la $a0, inputMessage
	la $a1, test
	la $a2, 40
	syscall
# $t0 - $t7 parameter
	
	la $t0, test
	jal deleteEndEnter
	nop

	# trim header cua string
	la $t0, test
	li $t1, NULL
	jal trimSpace
	nop
	
	# sau khi trim header cua string ma gap NULL thi -> error
	lb $t1, 0($t0)
	beq $t1, NULL, error
	nop
	
	
	# luu instruction name
	la $t1, insName
	la $t2, insNameLength
	li $t3, SPACE
	li $t4, NULL
	jal storeText
	nop
	
	# neu gap NULL thi chuyen -> next
	lb $t1, 0($t0)
	beq $t1, NULL, next
	nop
	
	# neu gap space thi trim tiep
	li $t1, NULL
	jal trimSpace
	nop
	
	# tach param 1
	la $t1, param1
	la $t2, param1Length
	li $t3, SPACE
	li $t4, COMMA
	jal storeText
	nop
	
	lb $t1, 0($t0)
	beq $t1, SPACE, space1
	nop
	beq $t1, COMMA, comma1
	nop
	beq $t1, NULL, next
	nop
	
# neu gap space
space1:
	li $t1, COMMA
	jal trimSpace
	nop
	
	# neu gap Null thi -> next, neu gap comma thi chuyen den comma1
	lb $t1, 0($t0)
	beq $t1, NULL, next
	nop
	beq $t1, COMMA, comma1
	nop
	
	# sau dau cach cua param 1 bat buoc phai la dau phay, khac day phay thi chuyen invalid 
	j invalidIns
	nop
	
comma1:
	addi $t0, $t0, 1 # bo qua dau phay
	
	# trim ultil meet NULL
	li $t1, NULL
	jal trimSpace
	nop
	
	# if the last char is NULL then invalidIns because after comma must be a register
	lb $t1, 0($t0)
	beq $t1, NULL, invalidIns
	nop

	# get the param 2	
	la $t1, param2
	la $t2, param2Length
	li $t3, SPACE
	li $t4, COMMA
	jal storeText
	nop
	
	# check the last char
	lb $t1, 0($t0)
	beq $t1, SPACE, space2
	nop
	beq $t1, COMMA, comma2
	nop
	beq $t1, NULL, next
	nop
	
space2:
	# neu gap space
	li $t1, COMMA
	jal trimSpace
	nop
	
	# neu gap Null thi -> next, neu gap comma thi chuyen den comma2
	lb $t1, 0($t0)
	beq $t1, NULL, next
	nop
	beq $t1, COMMA, comma2
	nop
	
	# sau dau cach cua param 2 bat buoc phai la dau phay, khac day phay thi invalidIns
	j invalidIns
	nop
	
	
comma2:
	addi $t0, $t0, 1 # ignore the COMMA
	
	# trim ultil meet NULL
	li $t1, NULL
	jal trimSpace
	nop
	
	# if the last char is NULL then invalidIns because after comma must be a register
	lb $t1, 0($t0)
	beq $t1, NULL, invalidIns
	nop
	
	# get the param 3
	la $t1, param3
	la $t2, param3Length
	li $t3, SPACE
	li $t4, NULL
	jal storeText
	nop
	
	# check the last char
	lb $t1, 0($t0)
	beq $t1, SPACE, space3
	nop
	beq $t1, NULL, next
	nop

space3:
	# if it is SPACE then trim until it meet NULL
	li $t1, NULL
	jal trimSpace
	nop
	
	#  if the last char is NULL -> next, if not -> ERROR because the last char of one line must be SPACE + NULL
	lb $t1, 0($t0)
	beq $t1, NULL, next
	nop
	bne $t1, NULL, invalidIns
	nop
	
	
# check each part of the instruction	
next:
	
	la $t0, insName	# $t0 & $t8 - dia chi cua string can check
	la $t1, _ins 	# $t1 - dia chi cua list 
			# $t2 - return
	la $t5, opcodeOK	# $t5 - Ok message
	la $t6, opcodeError	# $t6 - Error message
	jal checkStringInList
	nop
	
	add $s0, $t1, $0 # chuyen dia chi cua opcode tim dc sang $s0
	addi $s0, $s0, 1 # ignore the space char
	
	# get how many cycle of the ins
	# use $t1 - address
	jal ignoreChar
	nop
	
	addi $t1, $t1, -1
	lb $t2, 0($t1)
	
	la $t3, cycle
	sb $t2, 0($t3)
	
	
	# check param 1
	lb $t0, 0($s0)
	beq $t0, __1, checkRegisterParam1
	nop
	beq $t0, __4, checkLabelParam1
	nop
	
checkParam2:
	addi $s0, $s0, 1 # get the next type of param
	lb $t0, 0($s0)
	
	beq $t0, __0, checkZeroParam2
	nop
	beq $t0, __1, checkRegisterParam2
	nop
	beq $t0, __2, checkImmediateParam2
	nop
	beq $t0, __3, checkAddressParam2
	nop
	
	
	
checkParam3:
	addi $s0, $s0, 1 # get the next type of param
	lb $t0, 0($s0)
	
	beq $t0, __0, checkZeroParam3
	nop
	beq $t0, __1, checkRegisterParam3
	nop
	beq $t0, __2, checkImmediateParam3
	nop

aboutEnd:
	j end
	nop


########################
checkRegisterParam1:
	la $t0, param1	# $t0 & $t8 - dia chi cua string can check
	la $t1, _reg 	# $t1 - dia chi cua list 
			# $t2 - return
	la $t5, param1OK	# $t5 - Ok message
	la $t6, param1Error	# $t6 - Error message
	jal checkStringInList
	nop
	j checkParam2
	nop
	
########################
checkLabelParam1:
	# $t0 dia chi
	# $s1 - Ok message
	# $s2 - Error message
	
	la $t0, param1
	la $s1, param1OK
	la $s2, param1Error
	
	jal checkLabel
	nop
	
	j checkParam2
	nop
########################
checkZeroParam2:
	la $t0, param2 # get add of param2
	lb $t1, 0($t0) # get the byte
	
	# if that byte = \0 then OK, otherwise error
	beq $t1, 0, okZeroParam2
	nop
	j errorZeroParam2
	nop
okZeroParam2:
	# la $t9, param2OK
	# jal displayMessage
	# nop
	j end
	nop

errorZeroParam2:
	jal invalidInsReg
	nop
	
	j end
	nop
########################
checkRegisterParam2:
	la $t0, param2	# $t0 & $t8 - dia chi cua string can check
	la $t1, _reg 	# $t1 - dia chi cua list 
			# $t2 - return
	la $t5, param2OK	# $t5 - Ok message
	la $t6, param2Error	# $t6 - Error message
	jal checkStringInList
	nop
	j checkParam3
	nop
	
########################
checkImmediateParam2:
	# t0 dia chi
	# t7 OK
	# t8 error
	la $t0, param2
	la $t7, param2OK	# $t7 - Ok message
	la $t8, param2Error	# $t8 - Error message
	jal checkStringNumber
	nop
	j checkParam3
	nop
	
########################	
checkAddressParam2:	
# $t0 dia chi
# $t1 OK
# $t2 Error
	la $t0, param2
	la $t1, param2OK
	la $t2, param2Error	
	jal checkAddressParam
	nop
	j aboutEnd
	nop


		
########################
########################
checkZeroParam3:
	la $t0, param3 # get add of param2
	lb $t1, 0($t0) # get the byte
	
	# if that byte = \0 then OK, otherwise error
	beq $t1, 0, okZeroParam3
	nop
	j errorZeroParam3
	nop
okZeroParam3:
	# la $t9, param3OK
	# jal displayMessage
	# nop
	j end
	nop

errorZeroParam3:
	jal invalidInsReg
	nop
	
	j end
	nop
########################
checkRegisterParam3:
	la $t0, param3	# $t0 & $t8 - dia chi cua string can check
	la $t1, _reg 	# $t1 - dia chi cua list 
			# $t2 - return
	la $t5, param3OK	# $t5 - Ok message
	la $t6, param3Error	# $t6 - Error message
	jal checkStringInList
	nop
	j aboutEnd
	nop
	
########################
checkImmediateParam3:
	# t0 dia chi
	# t7 OK
	# t8 error
	la $t0, param3
	la $t7, param3OK	# $t7 - Ok message
	la $t8, param3Error	# $t8 - Error message
	jal checkStringNumber
	nop
	j checkParam3
	nop
	
########################	
	
		
			
				
					
						
							
								
									
											
	
	
##############################################################################################################################################################3

####### trimSpace ##################################################################################################################################
# $t0 la dia chi cua string 
# $t1 la ki tu ma ctr se dung khi gap
# $t2 la ki tu lay ra duoc tu $t0

# giu gia tri hien tai
trimSpace:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
isSpace:
	lb $t2, 0($t0)
	
	beq $t2, NULL, return_trimSpace
	nop
	
	beq $t2, $t1, return_trimSpace
	nop
	
	bne $t2, SPACE, return_trimSpace
	nop
	
subTrimHeader:
	jal trimHeader
	nop
	j isSpace
	nop
trimHeader: #
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	addi $t0, $t0, 1
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)	
	jr $ra

return_trimSpace:
	addi $sp, $sp, 4
	lw $ra, 0($sp)	
	jr $ra

##### end | trimSpace ##################################################################################################################################	





		
##### storeText ###################################################################################################################################	
# $t0 :	dia chi text de doc

# $t1 : dia chi de luu 

# $t2 : dia chi de luu length

# $t3 : ki tu 1 ma ctr se dung neu gap

# $t4 : ki tu 2 ma ctr se dung neu gap

# ------------------------------------------

# $t5 : ki tu doc duoc tu $t0

# $t6 : length



storeText:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	add $t6, $0, $0
	
isValidChar:
	lb $t5, 0($t0)
	
	beq $t5, $t3, return_storeText
	nop
	beq $t5, $t4, return_storeText
	nop
	beq $t5, NULL, return_storeText
	nop
	
subStoreText:
	addi $t0, $t0, 1 # increase address of text to read
	sb $t5, 0($t1)
	addi $t1, $t1, 1 # increase address (to store)
	addi $t6, $t6, 1 # increase length
	j isValidChar
	
return_storeText:
	sw $t6, 0($t2)

	addi $sp, $sp, 4
	lw $ra, 0($sp)	
	jr $ra
	
###### end | storeText ########################################################################################################################################	






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
	
	jal invalidInsReg
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

##### end | ignoreChar ##################################################################################################################################	

# $t0 dia chi
# $s1 - Ok message
# $s2 - Error message

# $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9

checkLabel:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	
	li $t5, _a
	li $t6, _z
	li $t7, _0
	li $t8, _9
	
		
checkFirstLabelLetter:
	lb $t2, 0($t0)
	
	beq $t2, 0, invalidLabel
	nop
	
	slt $t3, $t5, $t2 # a <= $t2
	slt $t4, $t2, $t6 # $t2 <= z
	
	and $t3, $t3, $t4
	beq $t3, 1, isLetterLabel
	nop
	bne $t3, 1, invalidLabel
	nop
	
checkNextLabelLetter:
	lb $t2, 0($t0)
	
	beq $t2, 0, validLabel
	nop
	
	slt $t3, $t5, $t2 # a <= $t2
	slt $t4, $t2, $t6 # $t2 <= z
	
	and $t3, $t3, $t4
	
	slt $t4, $t7, $t2 # 0 <= $t2
	slt $t9, $t2, $t8 # $t2 <= 9
	
	and $t4 , $t4, $t9
	
	or $t3, $t3, $t4
	
	beq $t3, 1, isLetterLabel
	nop
	bne $t3, 1, invalidLabel
	nop
	
	
isLetterLabel:
	addi $t0, $t0, 1
	j checkNextLabelLetter
	nop
	
validLabel:
	add $t9, $s1, $0
	jal displayMessage
	nop
	j return_checkLabel
	nop	

invalidLabel:
	add $t9, $s2, $0
	jal displayMessage
	nop
	
	jal invalidInsReg
	nop
	
	j end
	nop
	
return_checkLabel:
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra

###### check Label ########################################################################################################################################	






###### end | check Label ########################################################################################################################################	



####### check String Number ##################################################################################################################################
# t0 dia chi
# t7 OK
# t8 error

# $t1 so ki tu hop le

checkStringNumber:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	addi $t1, $t1, 0
	li $t5, _0
	li $t6, _9
	
checkCharNumber:
	lb $t2, 0($t0)
	
	beq $t2, 0, checkNULLNumber
	nop
	
	slt $t3, $t5, $t2 # a <= $t2
	slt $t4, $t2, $t6 # $t2 <= z
	
	and $t3, $t3, $t4
	beq $t3, 1, nextCharNumber
	nop
	bne $t3, 1, invalidNumber
	nop
	
checkNULLNumber:
	beq $t1, 0, invalidNumber
	nop
	
	j validNumber
	nop
	
nextCharNumber:
	li $t1, 1
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j checkCharNumber
	nop
	
validNumber:
	add $t9, $t7, $0
	jal displayMessage
	nop
	j return_checkStringNumber
	nop

invalidNumber:
	add $t9, $t8, $0
	jal displayMessage
	nop
	
	jal invalidInsReg
	nop
	
	j end
	nop
	
return_checkStringNumber:
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra

####### check String Number ##################################################################################################################################





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
	
	jal invalidInsReg
	nop
	
	j end
	nop

return_checkAddressParam:
	addi $sp, $sp, +4
	lw $ra, 0($sp)
	jr $ra
	

##### end | check Address Param  ##################################################################################################################################	






##### delete End Enter ##################################################################################################################################	

# $t0 dia chi

deleteEndEnter:
	j checkCharEnter
	nop
	
checkCharEnter:
	lb $t1, 0($t0)
	
	beq $t1, 0, return_deleteEndEnter
	nop
	
	beq $t1, ENTER, changeEnter
	nop
	
	addi $t0, $t0, 1
	j checkCharEnter
	nop
	
changeEnter:
	li $t1, 0
	sb $t1, 0($t0)
	j return_deleteEndEnter
	nop
	
return_deleteEndEnter:
	jr $ra

##### end | delete End Enter ##################################################################################################################################	


invalidIns:
	la $s0, insValid
	li $s1, 1
	sb $s1, 0($s0) 
	j next
	nop
	
invalidInsReg:
	la $s0, insValid
	li $s1, 1
	sb $s1, 0($s0) 
	jr $ra
	nop



# $t9 - dia chi cua Message
# $t8 - get byte from "cycle"
displayMessage:
	li $v0, 4
	add $a0, $0, $t9
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall
	
	jr $ra
	nop

error:
	li $v0, 4
	la $a0, errorMessage
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall

end:
	la $t9, cycle
	lb $t8, 0($t9)
	
	beq $t8, __1, displayMessage1
	nop
	beq $t8, __2, displayMessage2
	nop
	
	j return_end
	nop
	
displayMessage1:
	li $v0, 4
	la $a0, cycle1
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall
	
	j nextEnd
	nop

displayMessage2:
	li $v0, 4
	la $a0, cycle2
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall
	
	j nextEnd
	nop
	
	
	# check this ins is valid or not
nextEnd:
	la $t9, insValid
	lw $t8, 0($t9)
	
	# beq $t8, 0, displayMessage3
	# nop
	beq $t8, 1, displayMessage4
	nop
	
	j return_end
	nop
	
displayMessage3:
	li $v0, 4
	la $a0, okMessage
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall
	
	j return_end
	nop

displayMessage4:
	li $v0, 4
	la $a0, errorMessage
	syscall
	
	li $v0, 11
	li $a0, 0x0a
	syscall
	
	j return_end
	nop

return_end:	
	nop

	


