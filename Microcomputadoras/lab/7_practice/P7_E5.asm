	processor 16f877
	include	<p16f877.inc>
VALOR EQU H'20'	
VALOR1 EQU H'51'
VALOR2 EQU H'52'
VALOR3 EQU H'53'
CTE1 equ 70h		;cte1=70h
CTE2 equ 70h		;cte2=70h
CTE3 equ 70h		;cte3=70h
	ORG 0
	GOTO INICIO
	ORG 5  
INICIO:
	;Cambio al banco 01
	BSF STATUS,RP0
	BCF STATUS,RP1
	
	MOVLW h'0'
	MOVWF TRISB     ;Configura el puerto B como salida
	CLRF PORTB      ;Limpia los bits del PUERTO B
	
	BSF TXSTA,BRGH		;SELECCIÓN DE ALTA VELOCIDAD DE BAUDIOS
	MOVLW D'129'		
	MOVWF SPBRG			;Asignar 9600 BAUDS

	BCF TXSTA,SYNC		;Modo de comunicación=0. Asíncrona
	BSF TXSTA,TXEN		;Activación de transmisión

	BCF STATUS,RP0	;Cambio al banco 0

	BSF RCSTA,SPEN		;Habilita el puerto Serie
	BSF RCSTA,CREN		;Activa la recepción continua en modo de comunicación asíncrona
	
	
	
RECIBE
	BTFSS PIR1,RCIF			;Revisa si se esta recibiendo datos
	GOTO RECIBE				;Repetir 
	
	MOVF RCREG,W			;w=RCREG
	MOVWF	VALOR			;Valor a comparar
	MOVWF	TXREG			;TXREG=W	Visualizar el dato en la terminal
	BSF STATUS,RP0			;Cambio banco 1
TRASMITE:
	BTFSS TXSTA,TRMT		;Revisar si se transmite información	
	GOTO TRASMITE			;Repetir
	BCF STATUS,RP0			;Cambio a banco 0

SALIDA
							;Se revisará si entra a la terminal un D O I
	MOVLW	A'D'			
	XORWF	VALOR,W			;Comparar Si es 'D'
	BTFSC	STATUS,Z		
	GOTO	SAL_D		;Si es igual ve a SAL_D
	
	MOVLW	A'd'			
	XORWF	VALOR,W			;Comparar Si es 'd'
	BTFSC	STATUS,Z		
	GOTO	SAL_D			;Si es igual ve a SAL_D
	
	
	MOVLW	A'I'			
	XORWF	VALOR,W			;Comparar si es 'I'
	BTFSC	STATUS,Z
	GOTO	SAL_I			;Si es igual ve a SAL_I

	MOVLW	A'i'			
	XORWF	VALOR,W			;Comparar si es 'I'
	BTFSC	STATUS,Z
	GOTO	SAL_I			;Si es igual ve a SAL_I	

NONE
	CLRF	PORTB
	GOTO	RECIBE

SAL_D
	
	MOVLW	0X80
	MOVWF	PORTB			;PORTB=0X80
	BCF		STATUS,C		;Limpiar C
	CALL	RETARDO
LOOP_D
	RRF		PORTB			;Recorrimiento a la derecha
	CALL 	RETARDO
	BTFSS	STATUS,C		;Si el C=1?
	GOTO	LOOP_D			;Si C=0 repetir recorrimiento
	GOTO	RECIBE			;Seguir recibiendo

SAL_I
	
	MOVLW	0X01			
	MOVWF	PORTB			;PORTB=0X01
	BCF		STATUS,C		;Limpiar C
	CALL	RETARDO
LOOP_L
	RLF		PORTB			;Recorrimiento a la izquierda
	CALL	RETARDO
	BTFSS	STATUS,C		;Si el C=1?
	GOTO	LOOP_L			;Si C=0 repite recorrimiento
	GOTO	RECIBE			;Si C=1 Seguir recibiendo

RETARDO 
		MOVLW CTE1			;W=20H
		MOVWF VALOR1		;valor1=20H
TRES
	MOVLW CTE2		;W=50H
	MOVWF VALOR2	;valor2=50H
DOS
	MOVLW CTE3		;W=60h
	MOVWF VALOR3	;valor3=60H
UNO
	DECFSZ VALOR3	;Decementa valor3 -1
	GOTO UNO	;Si el resultado es diferente de 0 ir a uno
	DECFSZ VALOR2	;Decementa valor2 -1
	GOTO DOS	;Si el resultado es diferente de 0 ir a dos
	DECFSZ VALOR1	;Decementa valor1 -1
	GOTO TRES	;Si el resultado es diferente de 0 ir a tres
	RETURN
	END