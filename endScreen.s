.section .text
.global drawGameOver

@------------drawing game over panel--------------------------------------------------

drawGameOver:
	push	{r4-r5, lr}

	ldr	r2, =gameOverASCII
	mov	r0, #0
	mov	r1, #0

	ldr	r4, =width
	mov	r5, #768
	str	r5, [r4]

	ldr	r4, =height
	mov	r5, #960
	str	r5, [r4]

	bl	drawObj

	pop	{r4-r5, pc}	


