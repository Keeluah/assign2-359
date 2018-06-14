.section .text
.global snesRead
snesRead:				//beginning of snes loop
	push	{r4-r8, lr}
	
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

endReadLoop:				//if button pressed
	cmp	r4, #3			//if start is pressed
	beq	end			//terminate


					//checks if second bit was 0 (pressed), all instructions same as b, but using message for current button
	cmp	r4, #4
	bne	isUp
	mov	r0, r4
	b	endRead
isUp:
	cmp	r4, #5
	bne	isA
	mov	r0, r4
	b	endRead

isA:
	cmp	r4, #8
	bne	isY
	mov	r0, r4
	b	endRead

isY:
	cmp	r4, #1
	bne	isJLeft
	mov	r0, r4
	b	endRead

isJLeft:
	cmp	r4, #6
	bne	isJRight
	mov	r0, r4
	b	endRead

isJRight:				//checks if second bit was 0 (pressed), all instructions same as b, but using message for current button
	cmp	r4, #7
	bne	isSelect
	mov	r0, r4
	b	endRead

isSelect:
	cmp	r4, #2
	bne	isNone
	mov	r0, r4
	b	endRead

end:					//ending program
	ldr	r0, =terminating	//print end message
	bl	printf
	b	exit			//exit program

isNone:
	mov	r4, #0
	mov	r0, r4

endRead:
	pop	{r4-r8, pc}
