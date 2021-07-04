	processor 16f877
	include <p16f877.inc>

valor1 	EQU 	h'21' 	;valor1=h'21'
valor2 	EQU 	h'22'	;valor2=h'22'
valor3 	EQU 	h'23'	;valor3=h'23'
cte1 	EQU		08h		;cte1=20h
cte2	EQU		50h		;cte2=50h
cte3	EQU		60h		;cte3=60h

		ORG 	0
		GOTO	INICIO
INICIO: 
		BSF STATUS,RP0	;RP0='1'	
		BCF STATUS,RP1	;RP1='0'
		MOVLW 	H'0'	;W=00H
		MOVWF	TRISB	;TRISB=00H
		BCF	STATUS,RP0	;RP0='0'
		CLRF	PORTB	;Limpia el Port B
LOOP2:
		BSF	PORTB,0		;Asigna 0 puerto B
		CALL RETARDO	;Llama a la subrutina de retardo
		BCF PORTB,0		;Limpia el puerto B
		CALL RETARDO	;Llama a función retardo
		GOTO LOOP2		;Llama a subrutina LOOP2
		
RETARDO:
		MOVLW	cte1	;Asigna W=20H
		MOVWF	valor1	;Asigna valor1=W
TRES:		
		MOVLW	cte2	;Asigna W=50H
		MOVWF	valor2	;Asigna valor2=W
DOS:	
		MOVLW 	cte3	;Asigna W=60H
		MOVWF	valor3	;Asigna valor3=W
UNO:	
		DECFSZ	valor3	;Decementa valor3 -1
		GOTO	UNO		;Si el resultado es diferente de 0 ir a uno
		DECFSZ	valor2	;Decremenar valor2 -1
		GOTO	DOS		;Si el resultado es diferente de 0 ir a dos
		DECFSZ	valor1	;Decremenar valor1 -1
		GOTO TRES		;Si el resultado es diferente de 0 ir a dos
		RETURN			
		END