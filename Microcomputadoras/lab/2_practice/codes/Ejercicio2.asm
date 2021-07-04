PROCESSOR 16f877
	INCLUDE <p16f877.inc>
MENOR	EQU H'40'
AUX1	EQU	H'41'
AUX2	EQU H'42'
INFO	EQU	H'43'
		ORG 0
		GOTO INICIO
		ORG 5
INICIO:	MOVLW	H'20'
		MOVWF	FSR
REVISION:
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX1; Carga el valor de w en aux1
		INCF	FSR;incrementa el apuntador FSR
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX2; Carga el valor de w en aux2
		INCF	FSR; incrementa el valor de FSR
RESTA:	
		MOVF	AUX1,W; Mueve el dato de aux1 a W
		SUBWF	AUX2,W; Del valor de W le restas AUX2, lo pasa a W
		MOVWF	INFO; Información de la resta
		BTFSS	STATUS,0; Si c==1	aux1 es menor, si c==0 aux2 es menor
		GOTO	CASOAUX2; Si es menor aux2 ir a CASOAUX2
		GOTO	CASOAUX1; Si es menor aux1 ir a CASOAUX1
CASOAUX1:
		MOVF	AUX1,W; Carga el valor de aux1 a W
		MOVWF	MENOR; Carga el valor de W a Menor
		GOTO	REVISION2; Dirigir a REVISION2
CASOAUX2:
		MOVF	AUX2,W; Carga el valor de aux2 a W
		MOVWF	MENOR; Carga el valor de W a Menor
		GOTO	REVISION2; Dirigir a REVISION2
REVISION2:
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX1; Carga el valor W1 en aux1
		INCF	FSR; incrementa el FSR
		MOVF	MENOR,W; Carga el valor de Menor en E
		MOVWF	AUX2; carga el valor de W en aux2
		BTFSS	FSR,6; Si llega a 0x40zz
		GOTO	RESTA; si FSR,6==0
		GOTO 	FIN
FIN:
		BTFSC	FSR,0; Si llega a 0x41
		GOTO 	$	
		GOTO	RESTA; si FSR,0==1
		
		END
		