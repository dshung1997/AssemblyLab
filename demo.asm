.data
X: .word  0x30071982
Y: .word  0x17021996
.text
    lui  $1, 9
    addi $1, $1, 8

    li   $1, 0x00090008
    

   la $1, Y
   lw $7, 0($1)
