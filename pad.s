@ input: r0 - Button pressed (6 for right, 7 for left)
.global updatePad
updatePad:
  mov r5, r0    // saves r5
  mov r6, #2    // base speed of the paddle
  
  ldr r4, =paddlePosition
  ldr r7, [r4]  // loads x position
  
  
  tst r5, #6    // check if joypad right was pressed
  beq moveRight
  
  tst r5, #7    // check if joypad left was pressed
  beq moveLeft
  
  b end         // otherwise no button pressed to move pad
  
moveLeft:
  mov r8, #1  
  add r8, r7    // loads current position of the paddle
  sub r8. r6     // decrementing it to move left
  b savePosition
  
moveRight:
  mov r8, #1
  add r8, r7    // loads current position of the paddle
  add r8. r6    // incrementing it to move right
 
savePosition:
  ldr r4, =paddlePosition
  str r7, [r4]      // overwrites paddle position

end:
  mov lr, pc        // leaves subroutine

@ Data section
.section .data

paddlePosition:
.int  338        // x position 9 blocks from the left
.int  882        // y position 26 blocks from the top

