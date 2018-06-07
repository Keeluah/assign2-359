//Program written by Kevin Ng 30029178 and Jason Dam 30029092
@The Program
.section	.text

Init_GPIO:				//general initializing GPIO line instruction, this was done similarly to the way it was shown in lecture
	mov	r2, r0			//move argument to r2
	ldr	r0, =GpioPtr		//gpio base address
	ldr	r0, [r0]		//load copy into r0

initLoop:				//initializing loop
	cmp	r2, #9			//check which GPFSEL level by comparing pin number to 9
	subhi	r2, #10			//subtract by 10 if greater than 9
	addhi	r0, #4			//add 4 to base address
	bhi	initLoop		//loops again to check GPFSEL level

	add	r2, r2, lsl#1		//checking pins
	lsl	r1, r2			//left shift by argument passed for the bits
	mov	r3, #7			//move #0b111 into r3 for clearing
	lsl	r3, r2			//line up #7 with bits

	ldr	r2, [r0]		//load address
	bic	r2, r3			//bit clears the bits at the address
	orr	r2, r1			//input functional code passed as r1
	str	r2, [r0]		//stores address
	
	mov	pc, lr			//return out of subroutine
	
write_Latch:				//writing 0 or 1 to the latch of snes, this was done similarly to the way it was shown in lecture
	ldr	r0, =GpioPtr		//base address
	ldr	r0, [r0]		//loads it into r0
	mov	r3, #1			//moves 1 to set or clear
	lsl	r3, #9			//pin #9
	teq	r1, #0			//check if argument (to write or clear) is zero
	streq	r3, [r0, #40]		//if so, GPCLR address
	strne	r3, [r0, #28]		//else, write address

	mov	pc, lr			//return

write_Clock:				//write 0,1 to clock, this was done similarly to the way it was shown in lecture
	ldr	r0, =GpioPtr		//base address
	ldr	r0, [r0]		//loads

	mov	r3, #1			//1 to set or clear
	lsl	r3, #11			//pin #11
	teq	r1, #0			//checks if write 0 or 1
	streq	r3, [r0, #40]		//GPCLR address
	strne	r3, [r0, #28]		//write address

	mov	pc, lr			//return

read_Data:				//read from data line, this was done similarly to the way it was shown in lecture
	ldr	r0, =GpioPtr		//base
	ldr	r0, [r0]		//loads

	ldr	r1, [r0, #52]		//loads address of read to r1
	mov	r3, #1			//code 1 to read
	lsl	r3, #10			//pin #10
	and	r1, r3			//and bits
	teq	r1, #0			//checks output
	
	moveq	r0, #0			//if out put = 0, argument = 0
	movne	r0, #1			//else argument = 1


	mov	pc, lr			//return

read_Snes:				//main reading from snes
	push	{lr}			//push the link reg

	mov	r1, #1			//arg to write clock
	bl	write_Clock		//call subroutine

	mov	r1, #1			//arg to write latch
	bl	write_Latch

	mov	r0, #12			//microseconds to delay
	bl	delayMicroseconds	//delay
	mov	r1, #0			//clear latch
	bl	write_Latch
	
	pop	{lr}			//pop link reg
	mov	r4, #0			//button sample
	mov	r5, #0			//loop var
	
pulse_Loop:				//pulse loop for inputs
	push	{r4}			//push reg into stack
	push	{r5}
	push	{lr}
	
	mov	r0, #6			//delay 6 microsecond
	bl	delayMicroseconds

	mov	r1, #0			//clear clock
	bl	write_Clock
	
	mov	r0, #6			//delay 6 microseconds
	bl	delayMicroseconds

	bl	read_Data		//read data from data

checkPressed:				//check if button pressed
	pop	{lr}			//pop reg from stack
	pop	{r5}
	pop	{r4}
	
	cmp	r0, #0			//check if read data pass to 0
	bgt	nothingPressed		//if greater than 0, so 1, nothing is pressed
	lsl	r4, #1			//shift sample number by 1 to left
	b	updateButtons		//update the button data
		
nothingPressed:				//nothing pressed, also shift sample left by 1
	lsl	r4, #1
	add	r4, #1			//add 1 to sample button, so least significant digit is one (so in the end, we have 1111111111111111)

updateButtons:				//update the buttons
	add	r5, #1			//add to loop var
	push	{r4}			//push
	push	{r5}
	push	{lr}
	
	mov	r1, #1			//write to clock
	bl	write_Clock

	pop	{lr}			//pop reg
	pop	{r5}
	pop	{r4}	

	cmp	r5, #16			//see if we looped 16 times, for all inputs
	blt	pulse_Loop		//if not pusle loop again for next input

	mov	r0, r4			//pass button sample data as argument

	mov	pc, lr			//return

haltLoop$:				//haltloop from "sample program" on d2l
	b		haltLoop$

//data section of code for all strings, constants, etc.
.section .data

//align by 2 bits and make GpioPtr global to be used by other files
.align 2
.global GpioPtr
GpioPtr:
	.int	0	@ GPIO base address
