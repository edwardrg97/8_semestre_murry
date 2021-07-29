	processor 16f877
	include	<p16f877.inc>
	
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

RECIBE:					
	BTFSS PIR1,RCIF		;Revisa si la recepción ha sido completada
	GOTO RECIBE			;Si aun está en recepción de proceso repite
		
	MOVF RCREG,W		;En la recepción completada, 
						;se puede obtener la información por medio de RCREG
						;W=RCREG
	MOVWF TXREG			;TXREG=W
						;Registro para mandar a transmitir
	
	BSF STATUS,RP0		;Cambio a banco 1

TRANSMITE:
	BTFSS TXSTA,TRMT	;Revisa si ha transmitido el dato
	GOTO TRANSMITE		;Si no repite el proceso
	BCF STATUS,RP0		;Cambio al banco 0
	GOTO RECIBE			;Repite la recepción

	END
	