@ The information to drawing and storing information for the map
.section    .text

.global drawMap
drawMap:
	bl	drawBackground

drawBackground:
  @ ask for frame buffer information
	ldr	r0, =frameBufferInfo 	@ frame buffer information structure
	bl	initFbInfo
	mov	r9, #0
	mov	r8, #0
	ldr	r6, =startPositions			@ x
	ldr	r6, [r6]
	ldr	r7, =startPositions			@ y
	ldr	r7, [r7, #4]

xDimLoop:
	mov	r0, r6
	mov	r1, r7

	ldr	r2, =0x00000000 	@ colour
	bl	DrawPixel

	ldr	r2, =dimensions
	ldr	r2, [r2]		@0 = offset for X
	cmp	r8, r2
	bge	yDimLoop
	add	r6, #1
	add	r8, #1
	b	xDimLoop

yDimLoop:
	ldr	r2, =dimensions
	ldr	r2, [r2, #4]		@offset for Y dimension
	cmp	r9, r2
	bge	stopLoop
	mov	r8, #0
	ldr	r6, =startPositions
	ldr	r6, [r6]
	add	r7, #1
	add	r9, #1
	b	xDimLoop

stopLoop:
	@ stop
	haltLoop$:
	b	haltLoop$

@ Draw Pixel
@  r0 - x
@  r1 - y
@  r2 - colour

DrawPixel:
  push		{r4, r5}

	offset	.req	r4

	ldr	r5, =frameBufferInfo	

	@ offset = (y * width) + x
	
	ldr	r3, [r5, #4]		@ r3 = width
	mul	r1, r3
	add	offset,	r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl	offset, #2

	@ store the colour (word) at frame buffer pointer + offset
	ldr	r0, [r5]		@ r0 = frame buffer pointer
	str	r2, [r0, offset]

	pop	{r4, r5}
	bx	lr

@ Data section
.section .data

.align
.globl frameBufferInfo
frameBufferInfo:
	.int	0		@ frame buffer pointer
	.int	0		@ screen width
	.int	0		@ screen height

dimensions:
	.int	640		@x
	.int	960		@y

startPositions:
	.int	50		@x start
	.int	50		@y start
