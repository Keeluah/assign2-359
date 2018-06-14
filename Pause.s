@code section
.section .text
.global Pause
.global Restart
Pause:
	push	{r4, lr}
	bl	snesRead
	teq	r0, #2		// check if select is pressed
	beq	Stop		// stop the game if select is pressed
	pop	{r4, pc}	// continue the game	

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

	ldr	r4, =mapData
	ldr	r5, =backUpMap
	str	r5, [r4]

	bl 	drawHome		// goes back to the main menu

Restart:
	push	{r4, lr}
	bl	snesRead
	teq	r0, #3		// check if select is pressed
	beq	loop		// stop the game if select is pressed
	pop	{r4, pc}	// continue the game

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

	ldr	r4, =mapData
	ldr	r5, =backUpMap
	str	r5, [r4]

	bl 	mainLoop		// restarts the game 


		


	