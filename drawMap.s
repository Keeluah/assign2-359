.section .text
.global drawMap
.global	drawBorder
drawMap:
	push	{r4-r7, lr}
	bl	initDrawBg	
	mov	r5, #0
	mov	r6, #0
	ldr	r4, =startPositions

bgDrawLoopX:
	ldr	r2, =bgTiles	
	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	bl	drawObj
	teq	r5, #8
	beq	bgDrawLoopY
	add	r5, #1
	ldr	r4, =startPositions
	ldr	r7, [r4]
	add	r7, #64
	str	r7, [r4]
	b	bgDrawLoopX

bgDrawLoopY:
	mov	r7, #114
	str	r7, [r4]

	ldr	r7, [r4, #4]
	add	r7, #32
	str	r7, [r4, #4]

	teq	r6, #20
	beq	exitbg
	add	r6, #1
	mov	r5, #0
	b	bgDrawLoopX

exitbg:
	mov	r7, #114
	str	r7, [r4]
	mov	r7, #82
	str	r7, [r4, #4]
	pop	{r4-r7, pc}

@---------------Drawing the Border--------------------------------------------------

drawBorder:
	push	{r4-r7, lr}
	bl	initDrawBg
	mov	r5, #0
	mov	r6, #0
	ldr	r4, =startBorderPositions

drawTop:
	ldr	r2, =borderTileASCII	
	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	teq	r5, #11
	beq	drawLeftStart
	bl	drawObj
	add	r5, #1
	ldr	r4, =startBorderPositions
	ldr	r7, [r4]
	add	r7, #64
	str	r7, [r4]
	b	drawTop

drawLeftStart:
	mov	r5, #0
	mov	r7, #690
	str	r7, [r4]
	mov	r7, #50
	str	r7, [r4, #4]

drawLeft:
	ldr	r2, =borderTileASCII	
	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	teq	r5, #22
	beq	drawRightStart
	//beq	exitborderloop
	bl	drawObj
	add	r5, #1
	ldr	r4, =startBorderPositions
	ldr	r7, [r4, #4]
	add	r7, #32
	str	r7, [r4, #4]
	b	drawLeft

drawRightStart:
	mov	r5, #0
	mov	r7, #50
	str	r7, [r4]
	mov	r7, #50
	str	r7, [r4, #4]

drawRight:
	ldr	r2, =borderTileASCII	
	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	teq	r5, #22
	beq	exitborderloop
	bl	drawObj
	add	r5, #1
	ldr	r4, =startBorderPositions
	ldr	r7, [r4, #4]
	add	r7, #32
	str	r7, [r4, #4]
	b	drawRight

exitborderloop:
	mov	r7, #50
	str	r7, [r4]
	str	r7, [r4, #4]
	pop	{r4-r7, pc}
