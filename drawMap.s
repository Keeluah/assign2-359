.section .text
.global drawMap
drawMap:
	push	{r4-r9, lr}
	ldr	r4, =startPositions

	mov	r6, #0		// y = 0

forYLoop:
	
	mov	r7, #0		// x = 0
forXLoop:
	// loads arguments
	ldr	r2, [r4]	// loads x start
	ldr	r3, [r4, #4]	// loads y start
	
	mov	r0, r7		// saves x cell
	mov	r9, #64
	mul	r0, r9		// multiply it with width of a cell
	add	r0, r2		// align with start position

	mov	r1, r6		// saves y cell
	mov	r9, #32
	mul	r1, r9		// multiply with height of a cell
	add	r1, r3		// align with start position

	// calulate offset

	mov	r8, r6	// saves y
	mov	r9, #11
	mul	r8, r9	// y * 11
	add	r8, r7	// y * 11 + x (the array coordinate)
	
	ldr	r5, =mapData
	ldrb	r9, [r5, r8]	// loads the array, offsetting by y * |row| + x

// TESTS FOR CELL TYPES
testBGTile:
	cmp	r9, #0
	bne	testFirstTile
	bl	drawWallCell
	b	forXTest
	

testFirstTile:
	cmp	r9, #1
	bne	testSecondTile
	bl	drawPurpleCell
	b	forXTest

testSecondTile:
	cmp	r9, #2
	bne	testThirdTile
	bl	drawBlueCell
	b	forXTest

testThirdTile:
	cmp	r9, #3
	bne	testWallTile
	bl	drawRedCell
	b	forXTest

testWallTile:
	bl	drawBorderCell
	b	forXTest	

forXTest:
	add	r7, #1		// x++
	cmp	r7, #11
	bne	forXLoop
	
forYTest:	
	add	r6, #1		// y++
	cmp	r6, #21
	beq	exitLoop
	b	forYLoop

exitLoop:
	pop	{r4-r9, pc}