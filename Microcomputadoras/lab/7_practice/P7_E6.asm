	processor 16f877
	include	<p16f877.inc>
VALOR EQU H'20'	

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
	
	CLRF PORTB

	
	
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

GIROS
	MOVLW	A'S'			
	XORWF	VALOR,W			;Comparar Si es 'S'
	BTFSC	STATUS,Z		
	GOTO	ESTADO_1		;Si es igual ve a ESTADO_1

	MOVLW	A'A'			
	XORWF	VALOR,W			;Comparar Si es 'A'
	BTFSC	STATUS,Z		
	GOTO	ESTADO_2		;Si es igual ve a ESTADO_2
	
	MOVLW	A'T'			
	XORWF	VALOR,W			;Comparar Si es 'T'
	BTFSC	STATUS,Z		
	GOTO	ESTADO_3		;Si es igual ve a ESTADO_3

	MOVLW	A'D'			
	XORWF	VALOR,W			;Comparar Si es 'D'
	BTFSC	STATUS,Z		
	GOTO	ESTADO_4		;Si es igual ve a ESTADO_4

	MOVLW	A'I'			
	XORWF	VALOR,W			;Comparar Si es 'I'
	BTFSC	STATUS,Z		
	GOTO	ESTADO_5		;Si es igual ve a ESTADO_5

	GOTO RECIBE


ESTADO_1					;PARO PARO
	MOVLW 0X00
	MOVWF PORTB
	GOTO RECIBE
ESTADO_2					;DERECHA DERECHA
	MOVLW 0X36
	MOVWF PORTB
	GOTO RECIBE
ESTADO_3					;IZQUIERDA IZQUIERDA
	MOVLW 0X2D
	MOVWF PORTB
	GOTO RECIBE
ESTADO_4					;DERECHA IZQUIERDA
	MOVLW 0X35
	MOVWF PORTB
	GOTO RECIBE
ESTADO_5					;IZQUIERDA DERECHA
	MOVLW 0X2E
	MOVWF PORTB
	GOTO RECIBE


	END