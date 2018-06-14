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
	add	r8, #3	// moves right by 1
	add	r9, #3	// moves down by 1
	b 	collision

testSW:
	cmp	r7, #1	// check if direction flag is SW
	bne	testNE
	sub	r8, #3 	// moves left by 1
	add	r9, #3	// moves down by 1
	b	collision

testNE:
	cmp	r7, #2	// check if direction flag is NE
	bne	testNW	
	add	r8, #3	// moves right by 1
	sub	r9, #3	// moves up by 1
	b	collision		

testNW:
	cmp	r7, #3	// check if direction flag is NW
	bne	moveExit	// exits cause error in the direction flag
	sub	r8, #3	// moves left by 1
	sub	r9, #3	// moves up by 1

collision:
	mov	r0, r8	// passes new x position
	mov	r1, r9	// passes new y position
	mov	r2, r7	// passes on the ball direction
	bl	collisionCheck	// checks if new position collides with something
	cmp	r3, #1
	beq	moveExit
	cmp	r0, #0	// check if the flag is off
	beq	savePosition	// goes to save if it did not collide
	str	r1, [r4, #8]	// stores new direction
	mov	r7, r1	// change direction for the reloop
	b	testBall	// loops again with new direction

savePosition:
	str	r8, [r4]	// saves x position
	str	r9, [r4, #4]	// saves y position
	
moveExit:
	pop {r4-r9, pc}        // leaves subroutine

.global collisionCheck
@ input: r0 - x position, r1 - y position, r2 - direction
@ output: r0 - collision flag (1 for collided)
@	  r1 - ball direction (if changed)
collisionCheck:
	push {r4-r8, lr}

	mov	r4, r0	// saves x position
	mov	r5, r1	// saves y position
	mov	r6, r2	// saves direction

collideLeftWall:
	cmp	r4, #114
	bgt	collideRightWall
	cmp	r6, #1	// check if ball moving SW
	moveq	r6, #0	// change to SE if so
	cmp	r6, #3	// check if ball moving NW
	moveq	r6, #2	// change to NE if so
	b 	collided	// tells routine ball collided returns to calling

collideRightWall:
	ldr	r7, =screenRestrict
	ldr	r8, [r7, #4]
	add	r8, #48
	cmp	r4, r8
	blt	collideUpWall
	cmp	r6, #0	// check if ball moving SE
	moveq	r6, #1	// change to SW if so
	cmp	r6, #2	// check if ball moving NE
	moveq	r6, #3	// change to NW if so
	b 	collided	// tells routine ball collided returns to calling

collideUpWall:
	cmp	r5, #79
	bgt	collideBottom
	cmp	r6, #2	// check if ball moving NE
	moveq	r6, #0	// change to SE if so
	cmp	r6, #3	// check if ball moving NW
	moveq	r6, #1	// change to SW if so
	b 	collided

collideBottom:
	ldr	r7, =bottomScreen
	ldr	r8, [r7]
	cmp	r5, r8	// check if the ball hit the bottom of the screen
	blt	collidePad	// continues collision check otherwise

resetBall:
	ldr	r7, =ballPos	// loads address of ball position
	mov	r8, #0		
	str	r8, [r7, #12]	// set flag so ball stops moving freely
	mov	r8, #2
	str	r8, [r7, #8]	// set direction flag back to NE
	mov	r8, r5	
	sub	r8, #65
	str	r8, [r7, #4]	// places ball back ontop of the paddle
	mov	r3, #1
	b	exitCheck

collidePad:
	// checks y portion of the paddle
	ldr	r7, =paddlePosition
	ldr	r8, [r7, #4]	// loads pad's y position
	cmp	r5, r8
	blt	collideBrick
	add	r8, #4
	cmp	r5, r8
	bgt	collideBrick
	// check x portion of the paddle
	ldr	r8, [r7]	// load pad's x position
	cmp	r4, r8
	blt	collideBrick
	add	r8, #16
	cmp	r4, r8	// check if the ball hits the left edge of the paddle
	bgt	checkInsidePad
	mov	r6, #3	// change movement to NW
	b	collided
	
checkInsidePad:
	add	r8, #32
	cmp	r4, r8	// check if the ball hits the inside of the pad
	bgt	checkRightEdge
	cmp	r6, #0	// check if ball moving SE
	moveq	r6, #2	// change to NE if so
	cmp	r6, #1	// check if ball moving SW
	moveq	r6, #3	// change to SE if so	
	b	collided

checkRightEdge:
	add	r8, #16	
	cmp	r4, r8	// check if the ball hits the right edge of the paddle
	bgt	collideBrick
	mov	r6, #2	// change direction to NE
	b	collided	

collideBrick:
	mov	r0, #0
	b	exitCheck


collided:
	mov	r0, #1

exitCheck:
	mov	r1, r6
	pop {r4-r8, pc}

@ Data section
.section .data
.global ballPos
ballPos:
	.int	458	// x pos
	.int	674	// y pos
	.int	2	// direction (0 - SE, 1 - SW, 2 - NE, 3 - NW)
	.int	0	// flags if the ball has left the paddle

bottomScreen:
	.int 740