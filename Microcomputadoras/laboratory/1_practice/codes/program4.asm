#INCLUDE <P16F877A.INC>

ROTA EQU 0X20
	ORG 0
	GOTO INICIO
	
	ORG 5
INICIO:
	MOVLW 0X01	;W <-- 1
	MOVWF ROTA	;(ROTA) <-- W
CONTINUA:
	RLF ROTA,F	;(ROTA) <-- (ROTA)<<1
	BTFSC ROTA,7	;ROTA==1
	GOTO INICIO	
	GOTO CONTINUA	

	END