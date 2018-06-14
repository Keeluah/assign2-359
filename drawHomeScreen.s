.global drawHome
drawHome:
	push	{r4, lr}
	bl	initDrawHome

	ldr	r2, =menuScreen
	ldr	r4, =menuPos

	ldr	r0, [r4]
	ldr	r1, [r4, #4]

	bl 	drawObj
	bl	snesRead

	teq	r0, #5
	beq	drawHomeQ
	
	teq	r0, #8
	bne 	drawHome

	pop	{r4, pc}

drawHomeQ:
	push	{r4, lr}
	bl	initDrawHome
	
	ldr	r2, =menuScreenQ
	ldr	r4, =menuPos

	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	
	bl	drawObj
	bl 	snesRead

	//teq 	r0, #
	//beq	drawQuit

	teq	r0, #4
	beq	drawHome

	b	drawHomeQ

	pop	{r4,pc}

//drawQuit: