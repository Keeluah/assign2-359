@Creators - Kevin Ng

@Main code to run the program
.section  .text

.global main
main:
  bl  SnesRead
  bl  updateGame
  bl  drawGame
  

drawGame:
  bl  drawMap
  bl  drawPad
  bl  drawBall
  bl  drawBrick
  bl  drawWall
  
  bl  delay


delay:
  mov r0, #100
  bl  delayMicrosecond
  mov  pc, lr

@ Data section
.section .data
