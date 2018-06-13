.section .data
.global	drawBorderCell
@	r0 = x position
@	r1 = y position
drawBorderCell:
	push	{r4-r7, lr}
	bl	initDrawBg

	ldr	r2, =borderTileASCII	

	bl	drawObj

	pop	{r4-r7, lr}

.global	drawWallCell
@	r0 = x position
@	r1 = y position
drawWallCell:
	push	{r4-r7, lr}
	bl	initDrawBg

	ldr	r2, =bgTiles	

	bl	drawObj

	pop	{r4-r7, lr}

.global	drawPurpleCell
@	r0 = x position
@	r1 = y position
drawPurpleCell:
	push	{r4-r7, lr}
	bl	initDrawBg

	ldr	r2, =purpleBrickASCII	

	bl	drawObj

	pop	{r4-r7, lr}

.global	drawBlueCell
@	r0 = x position
@	r1 = y position
drawBlueCell:
	push	{r4-r7, lr}
	bl	initDrawBg

	ldr	r2, =blueBrickASCII	

	bl	drawObj

	pop	{r4-r7, lr}

.global	drawRedCell
@	r0 = x position
@	r1 = y position
drawRedCell:
	push	{r4-r7, lr}
	bl	initDrawBg

	ldr	r2, =redBrickASCII	

	bl	drawObj

	pop	{r4-r7, lr}
