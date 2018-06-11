.section .text
.global drawMap
drawMap:
	push	{r4-r7, lr}
	bl	initDrawBg
	ldr	r2, =bgTiles	
	mov	r5, #0
	mov	r6, #0
	ldr	r4, =startPositions

bgDrawLoopX:
	ldr	r2, =bgTiles	
	ldr	r0, [r4]
	ldr	r1, [r4, #4]
	bl	drawObj
	teq	r5, #11
	beq	bgDrawLoopY
	add	r5, #1
	ldr	r4, =startPositions
	ldr	r7, [r4]
	add	r7, #64
	str	r7, [r4]
	b	bgDrawLoopX

bgDrawLoopY:
	mov	r7, #50
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
	mov	r7, #50
	str	r7, [r4]
	str	r7, [r4, #4]
	pop	{r4-r7, pc}
