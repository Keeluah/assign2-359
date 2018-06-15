@code section
.section .text
.global Pause
.global Restart
Pause:
	push	{r4-r9, lr}
	bl	snesRead
	teq	r0, #2		// check if select is pressed
	beq	Stop		// stop the game if select is pressed
	pop	{r4-r9, pc}	// continue the game	

Stop:
	mov	r4, #200
	mov	r6, #2
	mul	r4, r6
	add	r4, #34  
	ldr	r5, =paddlePosition
	str	r4, [r5]		// resets the paddle position
	
	mov	r4, #200
	mov	r6, #2
	mul	r4, r6
	add	r4, #58  
	ldr	r5, =ballPos
	str	r4, [r5]		// resets the ball x position
	mov	r4, #200
	mov	r6, #3
	mul	r4, r6
	add	r4, #74
	str	r4, [r5, #4]		// resets the ball y position 

	ldr	r5, =mapData
	ldr	r6, =backUpMap
	mov	r7, #0 	
	bl	pauseFor

pauseFor:
	ldr	r4, =mapSize
	ldr	r8, [r4]
		

	ldrb	r9, [r6, r7]
	strb	r9, [r5, r7]

	add	r7, #1
	cmp	r7, r8
	bne	pauseFor

	mov	r0, #1
	pop	{r4-r9, pc}		// for loop is for setting all of the bricks back to the original position




Restart:
	push	{r4-r9, lr}
	bl	snesRead
	teq	r0, #3		// check if select is pressed
	beq	loop		// stop the game if select is pressed
	pop	{r4-r9, pc}	// continue the game

loop:
	mov	r4, #200
	mov	r6, #2
	mul	r4, r6
	add	r4, #34  
	ldr	r5, =paddlePosition
	str	r4, [r5]		// resets the paddle position
	
	mov	r4, #200
	mov	r6, #2
	mul	r4, r6
	add	r4, #58  
	ldr	r5, =ballPos
	str	r4, [r5]		// resets the ball x position
	mov	r4, #200
	mov	r6, #3
	mul	r4, r6
	add	r4, #74
	str	r4, [r5, #4]		// resets the ball y position 

	ldr	r5, =mapData
	ldr	r6, =backUpMap
	mov	r7, #0 	
	bl	restartFor

	mov	r0, #1
	pop	{r4-r9, pc}



restartFor:				// for loop is for setting all of the bricks back to the original position
	ldr	r4, =mapSize		
	ldr	r8, [r4]
		

	ldrb	r9, [r6, r7]
	strb	r9, [r5, r7]

	add	r7, #1
	cmp	r7, r8
	bne	pauseFor

	mov	r0, #1
	pop	{r4-r9, pc}


	mov	r0, #1
	pop	{r4-r9, pc}


		
.global mapSize
mapSize:
	.int	264

	