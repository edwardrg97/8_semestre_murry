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
							;Se revisará si entra a la terminal un 0 o 1
	MOVLW	A'1'			
	XORWF	VALOR,W			;Comparar Si es '1'
	BTFSC	STATUS,Z		
	GOTO	SAL1			;Si es igual ve a SAL1

	MOVLW	A'0'			
	XORWF	VALOR,W			;Comparar si es '0'
	BTFSC	STATUS,Z
	GOTO	SAL0			;Si es igual ve a SAL0
	
	GOTO RECIBE				;Si no es igual a alguno seguir recibiendo

SAL1
	BSF		PORTB,0			;Asignar 0x01 al puerto B
	GOTO	RECIBE			;Seguir recibiendo
SAL0
	BCF		PORTB,0			;Asignar 0x00 al puerto B
	GOTO	RECIBE			;Seguir recibiendo


	END	
	