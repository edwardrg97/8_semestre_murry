processor 16f877
include <p16f877.inc>
valor1 equ h'21'	;valor1=h'21'
valor2 equ h'22'	;valor2=h'22'
valor3 equ h'23'	;valor3=h'23'
cte1 equ 10h		;cte1=20h
cte2 equ 50h		;cte2=50h
cte3 equ 60h		;cte3=60h
	ORG 0
	GOTO INICIO
	ORG 5
INICIO 
    BSF STATUS,RP0		;RP0='1'
    BCF STATUS,RP1		;RP1='0'
    MOVLW H'0'			;W=00H
    MOVWF TRISB			;TRISB=00H
    BCF STATUS, RP0		;RP0='0'
    CLRF PORTB			;Limpia el port B

loop2
    MOVLW 0xFF			;Asignar FF al puerto B
    MOVWF PORTB			;W=PORTB
    CALL retardo		;Llama a la subrutina de retardo
    CLRF PORTB			;Limpia el puerto B
    CALL retardo		;Llama a la subrutina de retardo
    GOTO loop2			;llama a Loop2
	
retardo 
	MOVLW cte1			;W=20H
	MOVWF valor1		;valor1=20H
tres
		MOVLW cte2		;W=50H
        MOVWF valor2	;valor2=50H
dos 
		MOVLW cte3		;W=60h
        MOVWF valor3	;valor3=60H
uno 
		DECFSZ valor3	;Decementa valor3 -1
        GOTO uno		;Si el resultado es diferente de 0 ir a uno
        DECFSZ valor2	;Decementa valor2 -1
        GOTO dos		;Si el resultado es diferente de 0 ir a dos
        DECFSZ valor1	;Decementa valor1 -1
        GOTO tres		;Si el resultado es diferente de 0 ir a tres
        RETURN
        END


