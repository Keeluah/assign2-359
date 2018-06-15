
@ Code section
.section .text
.global	xDimLoop
.global main
.global gameScr
.global mainLoop
main:
	@ ask for frame buffer information
	ldr 	r0, =frameBufferInfo 	@ frame buffer information structure
	bl	initFbInfo

	bl	initializeDriver		//initialize drivers
	bl	drawHome

gameScr:	
	bl	drawMap
	bl	drawingElements
	//bl 	drawBorder
	
	

//menu doesnt work yet, segmentation error
//what does work is the moving the pad around and printing multiple things.
startScreen:
	//bl	drawHome
	bl	snesRead
	teq	r0, #7
	beq	mainLoop
	teq	r0, #6
	bne	startScreen

//successfully passes button press from snesRead
mainLoop:
	bl	snesRead
	mov	r7, r0
	bl	updatePad
	mov	r0, r7
	bl	updateBall
	bl	drawMap
	bl	drawingElements
	ldr	r0, =bPressed
	ldr	r1, =paddlePosition
	ldr	r1, [r1]
	bl	Pause
	cmp	r0, #1
	beq	drawHome
	bl	Restart
	cmp	r0, #1
	beq	mainLoop
	b	mainLoop


@ Data section
.section .data

.align 2
.global frameBufferInfo
.global	dimensions
.global startPositions
.global height

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
	.int	768		@x - 10 64 pixel wide tiles + 2 boarder tiles wide
	.int	960		@y - 64 x 16

.global	startPositions
startPositions:
	.int	50		@x start
	.int	50		@y start

.global	startBorderPositions
startBorderPositions:
	.int	50		@x start
	.int	50		@y start

.global prompt
prompt:
.asciz	"Please press button\n"

.global bPressed
bPressed:
.asciz	"Paddle is at x position %d\n"

.global terminating
terminating:
.asciz	"You have pressed start\nProgram is Terminating...\n"

.global paused
paused:
.asciz	"You have pressed select\nProgram is paused...\n"

.global mapData
mapData:
	.byte	4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4
	.byte	4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4
	.byte	4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4
	.byte	4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4
	.byte	4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4
	.byte	4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4

.global backUpMap
backUpMap:
	.byte	4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4
	.byte	4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4
	.byte	4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4
	.byte	4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4
	.byte	4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4
	.byte	4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4
	.byte	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4


.global	test
test:
	.asciz	"%d"