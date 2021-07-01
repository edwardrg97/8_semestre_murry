  processor 16f877      
  include <p16f877.inc> 
;AUX		EQU h'20'		;auxiliar para el recorrimiento
valor1 EQU h'21'		;valor1=h'21'
valor2 EQU h'22'		;valor2=h'22'
valor3 EQU h'23'		;valor3=h'23'
cte1 EQU 20h           	;cte1=20h
cte2 EQU 50h			;cte2=50h
cte3 EQU 60h			;cte3=60h

		ORG 0           ;Vector de RESET, origen de programa
		GOTO inicio 
		ORG 5
	   
inicio 
		BSF STATUS, RP0
		bcf STATUS, RP1 
		movlw h'0'
		movwf TRISB     ;Configurar puerto B como salida
		bcf STATUS,	RP0    ;Cambio BANCO 0
		clrf PORTB      ;Limpia los bits del PUERTO B
loop2 
		MOVLW H'80' ; W <= 80H
		BCF STATUS,0 ; CARRY <= ‘0’b
		MOVWF PORTB ; PORTB <= 80H
CICLO: 
		CALL retardo
		RRF PORTB,F ; Rota a la derecha PORTB
		BTFSS STATUS,0 ; skip si CARRY = ‘1’b
		GOTO CICLO
		GOTO loop2
       
	
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