; Coursework by Ricky Chan K23062540 due 24/11/2023
; Created in Notepad++

; to test Task 3 logic, you can comment out where i call the
; morseCodeFive, morseCodeNormal and morseCodeReverse functions
; and uncomment the divisibleByFiveTest, oddTest and evenTest if you would like.
; change line 44 from 50 to 10 to test a lower amount.
; (the counter value)


; ////////////////////////////////////////////////////////////////////////////////////////////////		

							; initialisation
.equ DDRB, 0x04				
.equ PORTB, 0x05
.equ DDRD, 0x0A
.equ PORTD, 0x0B

main:   
        ldi r16, 0x0F		; loads 00001111 into r16
        out DDRB, r16		; puts the lower 4 bits for output (00001111)

        ldi r16, 0xF0		; loads 11110000 into r16
        out DDRD, r16		; puts the upper 4 bits for output (11110000)	
		
; ////////////////////////////////////////////////////////////////////////////////////////////////		
		
		call kNumber 		; Task 1
		
		
		call buffer			; 3 second buffer to seperate the tasks
		
; ////////////////////////////////////////////////////////////////////////////////////////////////		
		
		call initials		; Task 2
		
		
		call buffer			; 3 second buffer to seperate the tasks
		
; ////////////////////////////////////////////////////////////////////////////////////////////////
		
							; Task 3
		ldi r22, 50  		; COUNTER
							; initialise loop counter of 50

mainloop:
		
		sbrs r22, 0 		; checks if bit 0 of r22 is set as 1. 
							; bit 0 as 1 = true (odd)
							; bit 0 as 0 = false (even)
						
		rjmp isEven 		; bit 0 of an even number is always 0. 
							; if sbrs returns false (even), it will not skip this step.
						
		rjmp isOdd 			; bit 0 of an odd number is always 1.
							; if sbrs returns true (odd), it will skip the previous step to this step.

isEven:
		call morseCodeReverse	; steps 1 - 7
		
		; call evenTest			; turns on led 1 for testing.
								
		rjmp divisorCheck

isOdd:
		call morseCodeNormal	; steps 1 - 7
		
		; call oddTest			; turns on led 8 for testing.
		
		rjmp divisorCheck

divisorCheck:
		mov r24, r22		; we want to do calculations to r22 without changing it
							; so we copy r22 to r24, we will use r24 to do calculations
							
		ldi r29, 5			; we will use r29 to subtract from and compare to r24
		
		loopDiv:			; loop to subtract 5 (r29) from r24 until it reaches 4 or lower
		
			sub r24, r29	; r24 - 5 (r29)
			
			cp r24, r29		; compares r24 and 5 (r29)
			
		brge loopDiv		; loop will continue subtracting 5 if r24 >= 5 (r29)
							; set of values that r24 could be after finishing the loop:
							; {4, 3, 2, 1, 0}
							; if r24 is 0, it is divisible by 5 because no remainder
		
		tst r24				; checks if r24 = 0.
		
		breq multipleOfFive ; if r24 = 0, then it will not skip this instruction.
		
		rjmp end			; if r24 != 0, then it will skip the previous instruction to this.

multipleOfFive:
		call interLetterSpace	; inter-letter space between RIC/CIR and 5
		call morseCodeFive		; adds 5 in morse code to either 
								; morseCodeNormal or morseCodeReverse
								; RIC5 or CIR5
								
		; call divisibleByFiveTest	; turns on leds 4 and 5 for testing.
		
end:	
		call interWordSpace ; step 8. for inter-word space
		
		dec r22				; decrease 50 counter by 1
		
		cpi r22, 0			; compares r22 to 0
		
		brne mainloop		; step 9. loop back to beginning of morse code sequence.
							; if r22 has not reached 0 yet, it will loop again
		
		call buffer			; 3 second buffer in between tasks

; ////////////////////////////////////////////////////////////////////////////////////////////////
							
pingPongLoop:				; Task 4
		call pingPong
		rjmp pingPongLoop
		
; ////////////////////////////////////////////////////////////////////////////////////////////////


							; ALL METHODS BELOW HERE


; delay for 0.1 seconds or 100 milliseconds
; credit to Josh Murphys example programs for loop idea
hundredMillisec:  
		; 5 cycles * r17 * r18 * r19 = number of cycles
		; 5 * 200 * 200 * 8 = 1600000
		; 1600000 / 16000000 = 0.1 seconds
		ldi r17, 200
        ldi r18, 200
        ldi r19, 8
		  
		loop1:  
			nop        		; 1 cycle
			dec r17    		; 1 cycle
			cpi r17, 0 		; 1 cycle
			brne loop1 		; 2 cycles when branching
		  
			ldi r17, 200	
			dec r18
			cpi r18, 0
			brne loop1
		  
			ldi r18, 200	
			dec r19
			cpi r19, 0
		brne loop1	  
ret


; delay for one second by looping hundredMillisec 10 times	  
oneSec:
		ldi r21, 10
		loop2:
			call hundredMillisec
			dec r21
			cpi r21, 0
		brne loop2
ret


; turning off the leds for 3 seconds to keep track of each task
buffer:
		ldi r21, 0x00
		out PORTB, r21
    	out PORTD, r21
		call oneSec
		call oneSec
		call oneSec
ret


; outputting k-number to leds (TASK 1)
kNumber:
		; kNumber is 23062540.
		
    	ldi r20, 0x02
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x03
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x00
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x06
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x02
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x05
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x04
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x00
    	out PORTB, r20
    	out PORTD, r20
		
		call oneSec
ret


; outputting initials to leds (TASK 2)
initials:
		; Ricky Chan so R.C which will be 18, 27, 3
		ldi r20, 0x12
		out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x1B
		out PORTB, r20
    	out PORTD, r20
		
		call oneSec
		
		ldi r20, 0x03
		out PORTB, r20
    	out PORTD, r20
		
		call oneSec
ret


; dot in morse code
dot:							; (200ms ON)
		ldi r20, 0xFF
		out PORTB, r20
		out PORTD, r20
		call hundredMillisec
		call hundredMillisec
ret


; dash in morse code
dash:							; (600ms ON)
		ldi r20, 0xFF
		out PORTB, r20
		out PORTD, r20
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
ret


; inter part space for morse code 
interPartSpace:					; (200ms OFF)
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
		call hundredMillisec
		call hundredMillisec
ret


; inter letter space between letters when writing out morse code
interLetterSpace:				; (600ms OFF) 
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
ret


; inter-word space between words when writing out morse code
interWordSpace:					; (1400ms OFF)
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
		call oneSec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
		call hundredMillisec
ret
		

; outputting RIC in morse code to leds
morseCodeNormal:
		; letter R
		call dot
		call interPartSpace
		call dash
		call interPartSpace
		call dot
		
		call interLetterSpace
		
		; letter I
		call dot
		call interPartSpace
		call dot
		
		call interLetterSpace
		
		; letter C
		call dash
		call interPartSpace
		call dot
		call interPartSpace
		call dash
		call interPartSpace
		call dot
		
		; morse code finished, turn leds off
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
ret


; outputting CIR in morse code to leds
morseCodeReverse:
		; letter C
		call dash
		call interPartSpace
		call dot
		call interPartSpace
		call dash
		call interPartSpace
		call dot
		
		call interLetterSpace
		
		; letter I
		call dot
		call interPartSpace
		call dot
		
		call interLetterSpace
		
		; letter R
		call dot
		call interPartSpace
		call dash
		call interPartSpace
		call dot
		
		; morse code finished, turn leds off
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
ret


; outputting 5 in morse code to leds
morseCodeFive:
		; 5
		call dot
		call interPartSpace
		call dot
		call interPartSpace
		call dot
		call interPartSpace
		call dot
		call interPartSpace
		call dot
		
		; morse code finished, turn leds off
		ldi r20, 0x00
		out PORTB, r20
		out PORTD, r20
ret


; repeating pattern of a single led switched on moving back and forth (TASK 4)
pingPong:
		ldi r20, 0x01
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x02
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x04
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x08
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x10
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x20
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x40
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x80
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x40
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x20
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x10
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x08
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x04
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x02
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		
		ldi r20, 0x01
		out PORTB, r20
		out PORTD, r20
ret


; turns on led 1 for 200ms for testing
evenTest:
		ldi r20, 0x01
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		call hundredMillisec
ret


; turns on led 8 for 200ms for testing
oddTest:
		ldi r20, 0x80
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		call hundredMillisec
ret


; turns on leds 4 and 5 for 200ms for testing
divisibleByFiveTest:
		ldi r20, 0x18
		out PORTB, r20
		out PORTD, r20
		
		call hundredMillisec
		call hundredMillisec
ret