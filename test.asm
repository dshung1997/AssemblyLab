.data # Vung du lieu, chua cac khai bao bien
x: .word 0x01020304 # bien x, khoi tao gia tri
message: .asciiz "Bo mon Ky thuat May tinh"

.text # Vung lenh, chua cac lenh hop ngu
start:
	jal end
	nop
	addi $t1, $t1, 1
	
end:
	addi $t1, $t1, 1
	b start
	nop
	
