	processor 16f877
	include	<p16f877.inc>
VALOR EQU H'20'
SAL	  EQU H'21'	
	ORG 0
	GOTO INICIO
	ORG 5  
INICIO:
	;Cambio al banco 01
	BSF STATUS,RP0
	BCF STATUS,RP1
	
	BSF TXSTA,BRGH		;SELECCIÓN DE ALTA VELOCIDAD DE BAUDIOS
	MOVLW D'129'		
	MOVWF SPBRG			;Asignar 9600 BAUDS

	BCF TXSTA,SYNC		;Modo de comunicación=0. Asíncrona
	BSF TXSTA,TXEN		;Activación de transmisión

	BCF STATUS,RP0	;Cambio al banco 0

	BSF RCSTA,SPEN		;Habilita el puerto Serie
	BSF RCSTA,CREN		;Activa la recepción continua en modo de comunicación asíncrona
	
	
INFO
						;Transmisión de los caracteres de 'HOLA UNAM'
						;El valor en ASCII se envia a partir del registo TXREG
	MOVLW	A'H'		
	MOVWF	TXREG
	CALL	CONF_TRANSM			;Subtrutina del camvio de banco 01
	MOVLW	A'O'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'L'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'A'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A' '		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'U'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'N'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'A'		
	MOVWF	TXREG
	CALL	CONF_TRANSM
	MOVLW	A'M'		
	MOVWF	TXREG
	CALL	CONF_TRANSM	
LOOP
	GOTO	LOOP

CONF_TRANSM
	BSF		STATUS,RP0		;Cambio al banco 1

TRANSMITIR
	BTFSS	TXSTA,TRMT		;Revisión de transmisión exitosa
	GOTO	TRANSMITIR
	BCF		STATUS,RP0		;Cambio al banco 0
	RETURN					;Regreso al último CALL

	END