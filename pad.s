@ Code section
.section .text

@ input: r0 - Button pressed (6 for right, 7 for left)
.global updatePad
updatePad:


@ Data section
.section .data

xMoveSpeed:
.int 8

yMoveSpeed:
.int 8

