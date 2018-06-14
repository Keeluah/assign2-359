@ Code section
.section .text
.global	updateBall

@ Input: r0 - snes button pressed
updateBall:
		push {r4-r9, lr}
	ldr	r4, =ballPos
	ldr	r5, [r4, #12] // loads ball start flag
	
	cmp	r5, #1	// check if the ball has started moving
	beq	freeMove	
	
	cmp	r0, #8	// check if a is pressed
	bne	stuckBall
	mov	r6, #1
	str	r6, [r4, #12]	// sets free ball flag to true
	b	freeMove

	//if the ball is not free, it will move with the paddle
	
stuckBall:
	ldr	r7, =paddlePosition
	ldr	r8, [r7]	// loads x position of the paddle
	mov	r9, r8		// saves r8
	add	r9, #24 	// aligns x position to the center of the paddle
	str	r9, [r4]	// stores ball position based on paddle position
	b	exitBall

freeMove:
	bl	freeMovement

exitBall:
	pop {r4-r9, pc}        // leaves subroutine


.global freeMovement
freeMovement:
	push {r4-r9, lr}
	ldr	r4, =ballPos
	ldr	r5, [r4] // loads x position
	ldr	r6, [r4, #4]	// loads y position
	ldr	r7, [r4, #8]	// loads direction of the ball

testBall:
	mov	r8, r5	// save x position
	mov	r9, r6	// save y position

testSE:	
	cmp	r7, #0	// check if direction flag is SE
	bne	testSW
	add	r8, #2	// moves right by 1
	add	r9, #2	// moves down by 1
	b 	collision

testSW:
	cmp	r7, #1	// check if direction flag is SW
	bne	testNE
	sub	r8, #2 	// moves left by 1
	add	r9, #2	// moves down by 1
	b	collision

testNE:
	cmp	r7, #2	// check if direction flag is NE
	bne	testNW	
	add	r8, #2	// moves right by 1
	sub	r9, #2	// moves up by 1
	b	collision		

testNW:
	cmp	r7, #3	// check if direction flag is NW
	bne	moveExit	// exits cause error in the direction flag
	sub	r8, #2	// moves left by 1
	sub	r9, #2	// moves up by 1

collision:
	mov	r0, r8	// passes new x position
	mov	r1, r9	// passes new y position
	bl	collisionCheck	// checks if new position collides with something

@returns collision flag in r0 and new direction in r1
	tst	r0, #0	// check if the flag is off
	beq	savePosition	// goes to save if it did not collide
	str	r1, [r4, #8]	// stores new direction
	b	testBall	// loops again with new direction

savePosition:
	str	r8, [r4]	// saves x position
	str	r9, [r4, #4]	// saves y position
	
moveExit:
	pop {r4-r9, pc}        // leaves subroutine

.global collisionCheck
@ input: r0 - x position, r1 - y position
@ output: r0 - collision flag (1 for collided)
@	  r1 - ball direction (if changed)
collisionCheck:
	push {r4-r8, lr}
	mov	r0, #0
	pop {r4-r8, pc}

@ Data section
.section .data
.global ballPos
ballPos:
	.int	458	// x pos
	.int	674	// y pos
	.int	2	// direction (0 - SE, 1 - SW, 2 - NE, 3 - NW)
	.int	0	// flags if the ball has left the paddle