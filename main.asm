; Curvy W/ Turn
; title  "curveTurn"
;
; Hardware Notes:
; PIC16F684 running at 4 MHz
;  
;   RA4 (right QTI) INPUTS
;   RA5 (left QTI) INPUTS
;    
;   RC0 right motor forward OUTPUTS
;   RC1 right motor backwards OUTPUTS
;   RC4 left motor forwards OUTPUTS
;   RC5 left motor backwards OUTPUTS
;       
; Esha Maheshwari
; 1/4/2020
;--------------------------------------------------------------------------
; Setup
    LIST R=DEC				
    INCLUDE "p16f684.inc" 
    INCLUDE "asmDelay.inc"

 __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTOSCIO

;  Variables
    CBLOCK 0x020 

    ENDC 
;--------------------------------------------------------------------------
PAGE

org    0
    movlw   7			    ;turn off Comparators
    movwf   CMCON0

    bsf     STATUS, RP0		    ;going into Bank 1
    clrf    ANSEL ^ 0x080	    ;all PORTS are Digital

    clrf    TRISC ^ 0X080	    ;teach all of PORT C to be outputs
    
    movlw   b'00110000'		    ;teach RA4 & RA5 of PORT A to be an input
    movwf   TRISA
    
    bcf	    STATUS, RP0		    ;going back into Bank 0
    
loop: 
    nop
    btfsc PORTA, 4		    ;if right QTI is white (RA4 right QTI, RA5 left QTI)
	call bothWhite
    btfss PORTA, 4		    ;if right QTI is black (RA4 right QTI, RA5 left QTI)
	call bothBlack
    goto loop
   
;--------------------------------------------------------------------------
PAGE
;Subroutines
 
right:				    ;if left QTI is black and right QTI is white
    Dlay 10000		    ;time it takes for wheels to be on vertex
    movlw b'00000001'		    ;move right motor forward (RC0)
    movwf PORTC
    Dlay 10000		    ;time it takes to turn 180 degrees
    btfss PORTA, 5		    ;if left QTI is black, keep going for a sec
    Dlay 10000
    btfsc PORTA, 5		    ;if left QTI is right, call bothWhite
    call bothWhite
    nop
    return
       
left:				    ;if left QTI is white and right QTI is black
    Dlay 10000			    ;time it takes for wheels to be on vertex
    movlw b'00010000'		    ;move left motor forward (RC4)
    movwf PORTC
    Dlay 10000			    ;time it takes to turn 180 degrees
    btfss PORTA, 4		    ;if right QTI is black, keep going for a sec
    Dlay 10000
    btfsc PORTA, 4		    ;if right QTI is white, call bothWhite
    call bothWhite
    nop
    return  
    
bothWhite:
    btfss PORTA, 5		    ;if left QTI is black and right QTI is white then turn right motor
	call right		    ;
    btfsc PORTA, 5		    ;if left QTI is white and right QTI is white, move straight
	movlw b'00010001'	    ;move right and left motor forward (RC0 & RC4)
	movwf PORTC		    
    nop
    return
    
bothBlack:
    btfsc PORTA, 5		    ;if left QTI is white and right QTI is black
	call left
    btfss PORTA, 5		    ;if left QTI is black
	call turn		    ;means both are black, so turn 

    return
    
turn:				    ;180 degree turn
    Dlay 10000
    movlw b'00100001'		    ;right motor forwards, left motor backawards
    movwf PORTC
    Dlay 10000
    btfsc PORTA, 5		    ;if left QTI senses white
	call whiteTurn
    call turn
    Dlay 10000		    ;time it takes to make 180 degree turn
    
whiteTurn:
    Dlay 10000
    btfss PORTA, 4		    ;if right QTI senses black while left QTI senses white
	call turn		    ;then keep turning (call the turn function)
    btfsc PORTA, 4		    ;if right QTI senses white while left QTI senses white (both have turned off the black)
	call ifLeftBlack	    ;call ifLeftBlack
  
ifLeftBlack:
    Dlay 10000
    movlw b'00100001'		    ;right motor forwards, left motor backawards (keep turning)
    movwf PORTC			    ;
    nop
    btfsc PORTA, 5		    ;if left QTI is still white,t hen call ifLeftBlack and keep going
	call ifLeftBlack    
    btfss PORTA, 5		    ;if left QTI is black, then go back to the initial loop
	return

end

Sharp Turns
title  "sharpTurns"
;
; Hardware Notes:
; PIC16F684 running at 4 MHz
;  
;   RA4 (right QTI) INPUTS
;   RA5 (left QTI) INPUTS
;    
;   RC0 right motor forward OUTPUTS
;   RC1 right motor backwards OUTPUTS
;   RC4 left motor forwards OUTPUTS
;   RC5 left motor backwards OUTPUTS
;       
; Esha Maheshwari
; 1/4/2020
;--------------------------------------------------------------------------
; Setup
    LIST R=DEC				
    INCLUDE "p16f684.inc" 
    INCLUDE "asmDelay.inc"

 __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTOSCIO

;  Variables
    CBLOCK 0x020 

    ENDC 
;--------------------------------------------------------------------------
PAGE

org    0
    movlw   7			    ;turn off Comparators
    movwf   CMCON0

    bsf     STATUS, RP0		    ;going into Bank 1
    clrf    ANSEL ^ 0x080	    ;all PORTS are Digital

    clrf    TRISC ^ 0X080	    ;teach all of PORT C to be outputs
    
    movlw   b'00110000'		    ;teach RA4 & RA5 of PORT A to be an input
    movwf   TRISA
    
    bcf	    STATUS, RP0		    ;going back into Bank 0
    
loop: 
    Dlay 3000000
    nop
    btfsc PORTA, 4		    ;if right QTI is white (RA4 right QTI, RA5 left QTI)
	call bothWhite
    btfss PORTA, 4		    ;if right QTI is black (RA4 right QTI, RA5 left QTI)
	call bothBlack
    goto loop
   
;--------------------------------------------------------------------------
PAGE
;Subroutines
 
right:				    ;if left QTI is black and right QTI is white
    Dlay 10000			    ;time it takes for wheels to be on vertex
    movlw b'00000001'		    ;move right motor forward (RC0)
    movwf PORTC
    Dlay 10000			    ;time it takes to turn 180 degrees
    btfss PORTA, 5		    ;if left QTI is black, keep going for a sec
    Dlay 10000
    btfsc PORTA, 5		    ;if left QTI is right, call bothWhite
    call bothWhite
    nop
    return
       
left:				    ;if left QTI is white and right QTI is black
    Dlay 10000		    ;time it takes for wheels to be on vertex
    movlw b'00010000'		    ;move left motor forward (RC4)
    movwf PORTC
    Dlay 10000``		    
    btfss PORTA, 4		    ;if right QTI is black, keep going for a sec
    Dlay 10000
    btfsc PORTA, 4		    ;if right QTI is white, call bothWhite
    call bothWhite
    nop
    return
    
bothWhite:
    btfss PORTA, 5		    ;if left QTI is black and right QTI is white then turn right motor
	call right		    ;
    btfsc PORTA, 5		    ;if left QTI is white and right QTI is white, move straight
	movlw b'00010001'	    ;move right and left motor forward (RC0 & RC4)
	movwf PORTC		    
    nop
    return
    
bothBlack:
    btfsc PORTA, 5		    ;if left QTI is white and right QTI is black
	call left
    btfss PORTA, 5		    ;if left QTI is black
	call turn		    ;means both are black, so turn 			    
    nop
    return
    
turn:				    ;180 degree turn
    Dlay 10000
    movlw b'00100001'		    ;right motor forwards, left motor backawards
    movwf PORTC
    Dlay 10000
    ;add a delay for like a microsecond here
    btfsc PORTA, 4		    ;means that right QTI is sensing white, not black anymore
	call nextTurn
    btfss PORTA, 4
	call turn
    
nextTurn:
    movlw b'00100001'
    movwf PORTC
    Dlay 10000
    btfsc PORTA, 5
	goto nextTurn
    btfss PORTA, 5
	goto loop
    
end

