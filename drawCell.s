.section .data
.global	drawBorderCell
@	r0 = x position
@	r1 = y position
drawBorderCell:
	push	{r4-r7, lr}
	mov	r4, r0	// save r0
	mov	r5, r1	// save r1
	
	bl	initDrawBg

	ldr	r2, =borderTileASCII	
	mov	r0, r4
	mov	r1, r5
	bl	drawObj

	pop	{r4-r7, pc}

.global	drawWallCell
@	r0 = x position
@	r1 = y position
drawWallCell:
	push	{r4-r7, lr}
	mov	r4, r0	// save r0
	mov	r5, r1	// save r1

	bl	initDrawBg

	ldr	r2, =bgTiles
	mov	r0, r4
	mov	r1, r5

	bl	drawObj

	pop	{r4-r7, pc}

.global	drawPurpleCell
@	r0 = x position
@	r1 = y position
drawPurpleCell:
	push	{r4-r7, lr}
	mov	r4, r0	// save r0
	mov	r5, r1	// save r1
	bl	initDrawBg

	ldr	r2, =purpleBrickASCII	
	mov	r0, r4
	mov	r1, r5

	bl	drawObj

	pop	{r4-r7, pc}

.global	drawBlueCell
@	r0 = x position
@	r1 = y position
drawBlueCell:
	push	{r4-r7, lr}
	mov	r4, r0	// save r0
	mov	r5, r1	// save r1
	bl	initDrawBg

	ldr	r2, =blueBrickASCII	
	mov	r0, r4
	mov	r1, r5

	bl	drawObj
	
	pop	{r4-r7, pc}

.global	drawRedCell
@	r0 = x position
@	r1 = y position
drawRedCell:
	push	{r4-r7, lr}
	mov	r4, r0	// save r0
	mov	r5, r1	// save r1
	bl	initDrawBg

	ldr	r2, =redBrickASCII	
	mov	r0, r4
	mov	r1, r5

	bl	drawObj
	
	
	pop	{r4-r7, pc}
