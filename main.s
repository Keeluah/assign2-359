
@ Code section
.section .text
.global	xDimLoop
.global main
main:
	@ ask for frame buffer information
	ldr 		r0, =frameBufferInfo 	@ frame buffer information structure
	bl		initFbInfo
	
	ldr	r0, =prompt		//user prompt message as argument
	bl	printf
	//bl		initializeDriver

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
	
//successfully passes button press from snesRead
mainLoop:
	bl	snesRead
	teq	r0, #6		//left
	bne	mainLoop
	bl	drawingElements
	b	mainLoop
	


@ Draw Pixel
@  r0 - x
@  r1 - y
@  r2 - colour

DrawPixel:
	push		{r4, r5}

	offset		.req	r4

	ldr		r5, =frameBufferInfo	

	@ offset = (y * width) + x
	
	ldr		r3, [r5, #4]		@ r3 = width
	mul		r1, r3
	add		offset,	r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl		offset, #2

	@ store the colour (word) at frame buffer pointer + offset
	ldr		r0, [r5]		@ r0 = frame buffer pointer
	str		r2, [r0, offset]

	pop		{r4, r5}
	bx		lr

initializeDriver:
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

	mov	pc, lr

@ Data section
.section .data

.align 2
.global frameBufferInfo
.global	dimensions
.global startPositions
.global height
.global paddle_position
paddle_position:
	.int	50
	.int	50
height:
	.int	0
.global width
width:
	.int	0
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

.global prompt
prompt:
.asciz	"Please press button\n"
.global bPressed
bPressed:
.asciz	"You have pressed %d\n"

.global terminating
terminating:
.asciz	"You have pressed start\nProgram is Terminating...\n"
