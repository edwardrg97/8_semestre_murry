PROCESSOR 16F877
#INCLUDE <P16F877.INC>

REC		EQU	H'40'; Informe de limite
LIM		EQU H'2F'; Limite de Rango
AUXM	EQU H'40'
AUX1	EQU	H'41'
AUX2	EQU H'42'
INFO	EQU	H'43'; Info resta
AUX_CANT	EQU H'44'; Contador de iteraciones
		ORG	0
		GOTO	INICIO
		ORG 5
INICIO:	;Inicialización de variables
		MOVLW	H'20'
		MOVWF	FSR
		MOVLW	LIM
		MOVWF	REC
		MOVLW	H'21'
		MOVWF	AUX_CANT
REVISION:
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX1; Carga el valor de w en aux1
		INCF	FSR;incrementa el apuntador FSR
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX2; Carga el valor de w en aux2
RESTA:	
		;Revision de numero menor
		MOVF	AUX1,W; Mueve el dato de aux1 a W
		SUBWF	AUX2,W; Del valor de AUX2 le restas W, lo pasa a W
		MOVWF	INFO; Información de la resta
		BTFSS	STATUS,0; Si c==1 revisa, si c==0 intercambia
		GOTO	INTERCAMBIO; Intercambia
		GOTO	REVISION2; Sigue revisando
INTERCAMBIO:
		;Intercambio entre valores 
		DECF	FSR
		MOVF 	AUX2,W
		MOVWF	INDF ;Menor a la izquierda
		INCF	FSR
		MOVF	AUX1,W
		MOVWF	INDF ;Mayor a la derecha
REVISION2:
		;Revision si el contador y el limite son iguales
		MOVF	AUX_CANT,W
		SUBWF	REC,W
		BTFSC	STATUS,Z; Si son iguales
		GOTO 	RESETEO; Reinicia el ciclo
		GOTO 	REV3; Sigue revisando
REV3:
		INCF	AUX_CANT
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX1; Carga el valor de w en aux1
		INCF	FSR;incrementa el apuntador FSR
		MOVF	INDF,W; Carga el valor de FSR en W
		MOVWF	AUX2; Carga el valor de w en aux2
		GOTO 	RESTA; Compara siguientes numeros
RESETEO:	
		; Reinicia el ciclo
		MOVLW	H'20'
		MOVWF	FSR
		MOVLW	H'21'
		MOVWF	AUX_CANT
		SUBWF	REC,W;	Limite - aux_cant
		BTFSC	STATUS,Z;Si es cero
		GOTO $	;Termina orden
		DECF	REC; Reduce limite
		GOTO REVISION;Revisar valores
		END