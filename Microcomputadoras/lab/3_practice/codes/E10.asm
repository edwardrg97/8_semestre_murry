processor 16f877      ;
include <p16f877.inc> 
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 90h          
cte2 equ 90h
cte3 equ 0A0h

       org 0          
       goto inicio 
       org 5
	   
inicio bsf STATUS, RP0  
       bcf STATUS, RP1 ;Cambio a Banco   
       movlw h'0'
       movwf TRISB    
       bcf STATUS, RP0  
       clrf PORTB      

loop2 
    movlw h'14' ;Estado 1 Verde 1 Rojo 2
    MOVWF PORTB 
    call retardo

    movlw h'24' ;Estado 2 Amarillo 1 Rojo 2
    MOVWF PORTB 
    call retardo
	
    movlw h'41' ;Estado 3 Rojo 1	Verde2
    MOVWF PORTB 
    call retardo

    movlw h'42' ; Estado 4 Rojo 1 	Amarillo 2
    MOVWF PORTB 
    call retardo

    goto loop2     
       
retardo 
		movlw cte1        	;W=20H
		movwf valor1		;valor1=20H
tres 
		movwf cte2			;W=50H
		movwf valor2		;valor2=50H
dos  
		movlw cte3			;W=60h
		movwf valor3		;valor3=60H
uno  
		decfsz valor3 		;Decementa valor3 -1
     	goto uno 			;Si el resultado es diferente de 0 ir a uno
     	decfsz valor2		;Decementa valor2 -1
     	goto dos			;Si el resultado es diferente de 0 ir a DOS
    	decfsz valor1   	;Decementa valor1 -1
    	goto tres			;Si el resultado es diferente de 0 ir a tres
     	return
     	end 

