.section .data
.global initializeDriver
initializeDriver:
	push	{r4, lr}
	gBase	.req	r7
	
	ldr	r0, =GpioPtr		//store gpio base for future use, example taken from lecture information
	bl initGpioPtr			//calls subroutine in GPIO_INIT.s

	ldr	r0, =GpioPtr
	ldr	gBase, [r0]		//loads a copy of base address
	
	//initialize Data, pin10
	mov	r0, #10			//pin number as argument, instructions are same for pin 9 and 11
	mov	r1, #0			//GPFSEL level
	bl	Init_GPIO		//call general initialize subroutine
	
	//initialize latch, pin09
	mov	r0, #9
	mov	r1, #1
	bl	Init_GPIO

	@initialize clock pin11
	mov	r0, #11
	mov	r1, #1
	bl	Init_GPIO

	pop	{r4, pc}
