@code section
.section .text
.global Pause
Pause:
	push	{r4, lr}
	bl	snesRead
	teq	r0, #2		// check if select is pressed
	beq	Stop		// stop the game if select is pressed
	pop	{r4, pc}	// continue the game	

Stop:
	bl drawHome