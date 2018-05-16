.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014

.eqv HEADING 0xffff8010 	# Integer: An angle between 0 and 359
				# 0 : North (up)
				# 90: East (right)
				# 180: South (down)
				# 270: West (left)
.eqv MOVING 0xffff8050 		# Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 	# Boolean (0 or non-0):
				# whether or not to leave a track
.eqv WHEREX 0xffff8030 		# Integer: Current x-location of
.eqv WHEREY 0xffff8040 		# Integer: Current y-location of

.data
	DCE:	.word 135, 5000, 0, 180, 17200, 1, 60, 2500, 1, 40, 2500, 1, 20, 2500, 1, 0, 7000, 1, 340, 2500, 1, 320, 2500, 1, 280, 2150, 1, 90, 12000, 0, 250, 3000, 1, 190, 7500, 1, 170, 7500, 1, 110, 3000, 1, 0, 17000, 0, 90, 7000, 0, 270, 4000, 1, 180, 8500, 1, 90, 4000, 1, 270, 4000, 0, 180, 8500, 1, 90, 4000, 1, 0, 1000, 0, 0, 0, 0
	CDE:	.word 110, 7000, 0, 250, 3000, 1, 190, 7500, 1, 170, 7500, 1, 110, 3000, 1, 0, 17000, 0, 90, 3000, 0, 180, 17200, 1, 60, 2500, 1, 40, 2500, 1, 20, 2500, 1, 0, 7000, 1, 340, 2500, 1, 320, 2500, 1, 280, 2150, 1, 90, 12000, 0, 270, 4000, 1, 180, 8500, 1, 90, 4000, 1, 270, 4000, 0, 180, 8500, 1, 90, 4000, 1, 1, 0, 1000, 0, 0, 0, 0
	EDC:	.word 110, 7000, 0, 270, 4000, 1, 180, 8500, 1, 90, 4000, 1, 270, 4000, 0, 180, 8500, 1, 90, 4000, 1, 0, 17000, 0, 90, 3000, 0, 180, 17200, 1, 60, 2500, 1, 40, 2500, 1, 20, 2500, 1, 0, 7000, 1, 340, 2500, 1, 320, 2500, 1, 280, 2150, 1, 90, 12000, 0, 250, 3000, 1, 190, 7500, 1, 170, 7500, 1, 110, 3000, 1, 1, 0, 1000, 0, 0, 0, 0

.text
main:
	add $t0, $zero, $zero	# t0 = 0
	li $t8, IN_ADRESS_HEXA_KEYBOARD
	li $t9, OUT_ADRESS_HEXA_KEYBOARD
	li $t1, 0x01
	li $t2, 0x02
	li $t3, 0x04
	add $t4, $zero, $t1		# row
		
	
get_value_loop:
	sb $t4, 0($t8) 		# must reassign expected row
	add $t0, $zero, $zero		# value
	beq $t4, $t1, case_row_1
	nop
	beq $t4, $t2, case_row_2
	nop
	beq $t4, $t3, case_row_3
	nop
case_row_1:
	lb $t0, 0($t9) 			# read scan code of key button
	beq $t0, 0x11, get_value_loop_end
	nop 
	add $t4, $zero, $t2
	j get_value_loop
	nop
case_row_2:
	lb $t0, 0($t9) 			# read scan code of key button
	beq $t0, 0x12, get_value_loop_end
	nop 
	add $t4, $zero, $t3
	j get_value_loop
	nop
case_row_3: 	
	lb $t0, 0($t9) 			# read scan code of key button
	beq $t0, 0x14, get_value_loop_end
	nop 
	add $t4, $zero, $t1
	j get_value_loop
	nop
get_value_loop_end:
		
switch:
	beq $t0, 0x11, case_1
	nop
	beq $t0, 0x12, case_2
	nop
	beq $t0, 0x14, case_3
	nop
case_1:
	la $s0, DCE
	j prepare_drawing
	nop
case_2:
	la $s0, CDE
	j prepare_drawing
	nop
case_3:
	la $s0, EDC
prepare_drawing:
			
	add $t9, $s0, $zero	#index = 0
	jal GO
	nop
draw_loop:
	
	lw $t0, 0($t9)		# Angle
	lw $t1, 4($t9)		# Time
	lw $t2, 8($t9)		# Track/Untrack
	bne $t0, $zero, DRAWING
	nop
	bne $t1, $zero, DRAWING
	nop
	bne $t2, $zero, DRAWING
	nop
	j exit
	nop
DRAWING:
rotate:
	add $a0, $zero, $t0 			# Rotate $t0 degree
	jal ROTATE
	nop
track:
	beq $t2, $zero, go_untrack		# $t2 = 0 --> Untrack
	nop
go_track:
	jal TRACK				# Track robot
	nop
	addi $v0,$zero,32 			# Keep running by sleeping in $t1 ms
	add $a0, $zero, $t1
	syscall
	jal UNTRACK 				# keep old track
	nop
	j continue
	nop
go_untrack:
	jal UNTRACK 				# Untrack robot
	nop
	addi $v0,$zero,32 			# Keep running by sleeping in $t1 ms
	add $a0, $zero, $t1
	syscall
	jal UNTRACK 				# keep old track
	nop
continue:
	addi $t9, $t9, 12			# update index
	j draw_loop
	nop	
exit:
	li $v0, 10
	syscall	
end_main:
#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO:
	li $at, MOVING # change MOVING port
	addi $k0, $zero,1 # to logic 1,
	sb $k0, 0($at) # to start running
	jr $ra
	nop
#-----------------------------------------------------------
# STOP procedure, to s 	top running
# param[in] none
#-----------------------------------------------------------
STOP:
	li $at, MOVING # change MOVING port to 0
	sb $zero, 0($at) # to stop
	jr $ra
	nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line
# param[in] none
#-----------------------------------------------------------
TRACK:
	li $at, LEAVETRACK # change LEAVETRACK port
	addi $k0, $zero,1 # to logic 1,
	sb $k0, 0($at) # to start tracking
	jr $ra
	nop
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#-----------------------------------------------------------
UNTRACK:
	li $at, LEAVETRACK # change LEAVETRACK port to 0
	sb $zero, 0($at) # to stop drawing tail
	jr $ra
	nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up) 
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE:
	li $at, HEADING # change HEADING port
	sw $a0, 0($at) # to rotate robot
	jr $ra
	nop
