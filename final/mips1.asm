.eqv SPACE 0x20
.eqv COMMA 0x2c
.eqv $100 0x24
.eqv a1 0x60
.eqv z1 0x7b

.data
	test: .asciiz "     addt     $1, $2       ,     $s3   "
	insName: .space 20
	param1: .space 20
	param2: .space 20
	param3: .space 20
	# instruction
	
	_ins: .asciiz "add", "sub"
	
	# number of params
	_npa: .word     3,     2
	
	# type of each param : 0 - dont have; 1 - register; 2 - immediate; 3 - imm($reg) ; 4 - label
	_pa1: .word     1,     1
	_pa2: .word     1,     1
	_pa3: .word     1,     0
	
	_regw: .asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
	_regn: .asciiz "$0", "$1", "$2", "$3", "$4", "$5", "$6", "$7", "$8", "$9", "$10", "$11", "$12", "$13", "$14", "$15", "$16", "$17", "$18", "$19", "$20", "$21", "$22", "$23", "$24", "$25", "$26", "$27", "$28", "$29","$30", "$31"
	
	
	# _test: .asciiz "add $v1, $3, $2"
	# _t: .space 100

.text
	# add $s1, $s1,$0
	la $s0, test
	la $s1, insName
	la $s2, param1
	la $s3, param2
	la $s4, param3

	
# input:
	# li $v0, 8
	# la $a0, _test
	# li $a1, 100
	# syscall
	
splitInsName:
	jal space
	nop
	jal splitInsName
	nop
	jal split
	nop
	

# Ham tach SPACE
space:
	lb $t1, 0($s0)
	beq $t1, SPACE, subSpace
	nop
	jr $ra
	nop
subSpace:
	addi $s0, $s0, 1
	j space
	nop
	
splitInsName:
	beq $t1, SPACE, subSplitInsName
	nop
	lb $t1, 0($s0)
	sb $t1, 0($s1)
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	
	j splitInsName
	nop
	
subSplitInsName:
	jr $ra
	nop
	
#####################################################
checkAZ:
	slt $t2, a1, $t1
	slt $t3, $t1, z1
	and $t4, $t3, $t2
	beq $t4, 1, isAZ
	nop
	beq $0, $0, isNotAZ
	
isAZ:
	li $t2, 1
	jal $ra
	
isNotAZ:
	li $t2, 0
	jal $ra
#####################################################	
end:
	
	
	
