
@ Code section
.section .text

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
	
snesLoop:				//beginning of snes loop
	ldr	r0, =prompt		//user prompt message as argument
	bl	printf
	
waitLoop:				//check button press/wait for a button press
	bl	read_Snes		//call subroutine to read data from snes controller
	mov	r4, #0			//loop counter
	mov	r5, #1			//button sampler
	lsl	r5, #15			//shift by 15
readLoop:				//loop for reading all inputs in one cycle
	mov	r6, r0			//returning argument from read_Snes into r6
	mov	r8, r0			//same as above for r8
	and	r6, r5			//and for checking button press
	cmp	r6, #0			//compare and r6 with a string of zeros
	beq	endReadLoop		//if they are equal, button is pressed, we assume one button pressed at a time
	add	r4, #1			//else, increment loop by 1
	lsr	r5, #1			//shift r5 right by one to check next bit
	cmp	r4, #16			//check if looped 16 times yet
	blt	readLoop		//if not read again with shifted number

	b	waitLoop		//if nothing has been pressed for 16 cycles, start wait loop again

endReadLoop:				//if button pressed
	cmp	r4, #3			//if start is pressed
	beq	end			//terminate
					//checks if second bit was 0 (pressed), all instructions same as b, but using message for current button
	cmp	r4, #6
	bne	isJRight
	ldr	r0, =0x00000000
	b	printClr

isJRight:				//checks if second bit was 0 (pressed), all instructions same as b, but using message for current button
	cmp	r4, #7
	bne	snesLoop
	ldr	r0, =0xFFFF0000
	b	printClr

printClr:
	b	startScreenDrw
	//b	snesLoop

pressHold:				//if a button is held
	bl	read_Snes		//read data from controller
	mov	r6, r0			//data argument is passed to r6
	cmp	r6, r8			//compare to old instruction
	bgt	letgo			//if not the same, they let go
	b	pressHold		//else keep looping until they let go

letgo:					//let go of button
	b	snesLoop		//beginning of loop

end:					//ending program
	ldr	r0, =terminating	//print end message
	bl	printf
	b	exit			//exit program

startScreenDrw:
	mov		r10, r0
	mov		r9, #0
	mov		r8, #0
	ldr		r6, =startPositions			@ x
	ldr		r6, [r6]
	ldr		r7, =startPositions			@ y
	ldr		r7, [r7, #4]

xDimLoop:
	mov		r0, r6
	mov		r1, r7

	mov		r2, r10 	@ colour
	bl		DrawPixel

	ldr		r2, =dimensions
	ldr		r2, [r2]		@0 = offset for X
	cmp		r8, r2
	bge		yDimLoop
	add		r6, #1
	add		r8, #1
	b		xDimLoop

yDimLoop:
	ldr		r2, =dimensions
	ldr		r2, [r2, #4]		@offset for Y dimension
	cmp		r9, r2
	bge		stopLoop
	mov		r8, #0
	ldr		r6, =startPositions
	ldr		r6, [r6]
	add		r7, #1
	add		r9, #1
	b		xDimLoop

stopLoop:
	b		snesLoop


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
prompt:
.asciz	"Please press button\n"

bPressed:
.asciz	"You have pressed %s\n"

terminating:
.asciz	"You have pressed start\nProgram is Terminating...\n"
