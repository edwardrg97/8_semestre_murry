PROCESSOR 16F877
#INCLUDE <P16F877.INC>

CONTA EQU 0X20
	ORG 0
	GOTO INICIO
	ORG 5
INICIO:
	CLRF CONTA		;Limpia CONTA
CONTINUA1:
	INCF CONTA,F	;Incrementa en 1 CONTA
	MOVF CONTA,W	;Mueve Conta a W.
	SUBLW 0X09		;Resta 09 a W.
	BTFSS STATUS,Z	;Si el STATUS Z==1
	GOTO CONTINUA1	;NO, ir a continua.
	MOVLW 0X10		;SI, Mover el valor de 10 a W
	MOVWF CONTA		;Mover el valor de W a CONTA
CONTINUA2:
	INCF CONTA,F	;Incrementa en 1 CONTA
	MOVF CONTA,W	;Mueve Conta a W.
	SUBLW 0X19		;Resta 19 a W
	BTFSS STATUS,Z	;Si STATUS Z==1
	GOTO CONTINUA2	;NO, Ir a Continua2
	MOVLW 0X20		;SI, Mover el valor de 10 a W
	MOVWF CONTA		;Mover el valor de W a Conta
	GOTO INICIO		;Reinicio de conteo.

	END