PROCESSOR 16F877
#INCLUDE <P16F877A.INC>

ROTA EQU 0X20
	ORG 0
	GOTO INICIO
	
	ORG 5
INICIO:
	MOVLW H'01'	;Mover el valor de 01 en W 
	MOVWF ROTA	;Mover el valor de W a Rota (H'20')
CONTINUE:
	RLF ROTA,F	; Recorre A LA IZQUIERDA.
	BTFSC ROTA,7	;SI el bit de en la posición 7 de la variable
	; rota es igual a 1
	GOTO INICIO		;Si es asi, dirigir a inicio
	GOTO CONTINUE	; si no es asi ve a continue

	END