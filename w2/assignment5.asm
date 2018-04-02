#Laboratory Exercise 2, Assignment 5
.text
# Assign X, Y
addi $t1, $zero, 999 # X = $t1 = ?
addi $t2, $zero, 999 # Y = $t2 = ?
addi $t3, $zero, 999 # Y = $t2 = ?
# Expression Z = 3*XY
mul $s0, $t1, $t2 # HI-LO = $t1 * $t2 = X * Y ; $s0 = LO
mul $s0, $s0, $t3 # $s0 = $s0 * 3 = 3 * X * Y
mul $s0, $s0, $t3
# Z' = Z
mflo $s1