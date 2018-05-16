.eqv SPACE 0x20
.eqv COMMA 0x2c
.eqv $100 0x24
.eqv aaaa 0x61
.eqv zzzz 0x7a

.data
	test: .asciiz "azbcd"
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
	
	_regw: .asciiz "$zero", "$at", "$v0", "$v1"
	_regn: .asciiz "$0", "$1", "$2", "$3", "$4"
	
	
	# _test: .asciiz "add $v1, $3, $2"
	# _t: .space 100

.text
	# add $s1, $s1,$0
	la $s0, test
	addi $s0, $s0, 3
	lb $s1, 0($s0)
	lb $s2, 1($s0)
	
	
	
	
	
	
