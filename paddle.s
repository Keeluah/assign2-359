@ input: r0 - Button pressed (6 for right, 7 for left)
.global updatePad
updatePad:
	push {r4-r8, lr}
  mov r5, r0    // saves r5
  mov r6, #5    // base speed of the paddle
  
  ldr r4, =paddlePosition
  ldr r7, [r4]  // loads x position
  
  
  teq r0, #7    // check if joypad right was pressed
  beq moveRight
  
  teq r0, #6    // check if joypad left was pressed
  beq moveLeft
  
  b end         // otherwise no button pressed to move pad
  

moveLeft:
	mov	r8, #0
	add	r8, r7    // loads current position of the paddle
	sub	r8, r6     // decrementing it to move left
	b	checkPos

moveRight:
	mov	r8, #0
	add	r8, r7    // loads current position of the paddle
	mov	r1, r7
	add	r8, r6    // incrementing it to move right

checkPos:
	ldr	r4, =screenRestrict
	ldr	r7, [r4]
	cmp	r8, r7
	ble	noChange
	ldr	r4, =screenRestrict
	ldr	r7, [r4, #4]
	cmp	r8, r7
	bge	noChange
	b	savePosition

noChange:
	mov	r8, r7

savePosition:
  ldr r4, =paddlePosition
  str r8, [r4]      // overwrites paddle position

end:
	pop {r4-r8, pc}        // leaves subroutine


@ Data section
.section .data
.global paddlePosition
screenRestrict:
	.int	178
	.int	690

paddlePosition:
.int  434        // x position 9 blocks from the left
.int  690        // y position 26 blocks from the top