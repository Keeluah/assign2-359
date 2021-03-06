@Use this to draw things
.section .text
.global drawingElements
drawingElements:
	push	{r4-r7, lr}

	bl	initDrawPaddle
	ldr	r2, =paddleASCII
	ldr	r4, =paddlePosition
	ldr	r0, [r4]		// x coord
	ldr	r1, [r4, #4]		// y coord
	bl	drawObj

	bl	initDrawBall
	ldr	r2, =ballASCII
	ldr	r4, =ballPos
	ldr	r0, [r4]		// x coord
	ldr	r1, [r4, #4]
	bl	drawObj

exitDrawElements:
	pop	{r4-r7, pc}


.global drawObj
@This will be used to draw objects
@	r0 = x
@	r1 = y
@	r2 = color data
drawObj:
	push		{r4, r5, r6, r7, r8, r9, lr}

	mov	r4, r2
	mov	r5, r0		//x
	mov	r6, r1		//y

	ldr	r9, =height
	ldr	r7, [r9]

drawColumn:
	ldr	r9, =width
	ldr	r8, [r9]

drawRow:
	mov	r0, r5
	mov	r1, r6

	ldr	r2, [r4], #4
	bl	drawPxl

	add	r5, #1
	subs	r8, #1
	bne	drawRow

	add	r6, #1
	ldr	r8, [r9]
	sub	r5, r8
	
	subs	r7, #1
	bne	drawColumn
	
	pop		{r4, r5, r6, r7, r8, r9, pc}

drawPxl:
	push	{r4-r8, lr}

	ldr	r5, =frameBufferInfo
	ldr	r3, [r5, #4]
	mul	r1, r3
	add	r4, r0, r1
	lsl	r4, #2

	mov	r6, #0xff000000
	mov	r7, #0x000000ff
	orr	r8, r6, r7
	mov	r6, #0x00ff0000
	orr	r8, r8, r6

	teq	r2, r8
	beq	skipPxl

	ldr	r0, [r5]
	str	r2, [r0, r4]

skipPxl:
	pop	{r4-r8, pc}

.global initDrawPaddle
initDrawPaddle:
	ldr	r0, =width
	mov	r1, #64
	str	r1, [r0]

	ldr	r0, =height
	mov	r1, #32
	str	r1, [r0]
	bx	lr

.global	initDrawBg
initDrawBg:
	ldr	r0, =width
	mov	r1, #64
	str	r1, [r0]

	ldr	r0, =height
	mov	r1, #32
	str	r1, [r0]
	bx	lr

.global initDrawBall
initDrawBall:
	ldr	r0, =width
	mov	r1, #16
	str	r1, [r0]

	ldr	r0, =height
	mov	r1, #16
	str	r1, [r0]
	bx	lr

.global initDrawHome
initDrawHome:
	ldr	r0, =width
	mov	r1, #704
	str	r1, [r0]

	ldr	r0, =height
	mov	r1, #704
	str	r1, [r0]
	bx	lr


.section .data
.global menuPos
prompt:
	.asciz	"test"
menuPos:
	.int 50
	.int 50