processor 16f877
include <p16f877.inc>

in_He	equ h'20'	; Input hexadecimal
outD_C	equ h'21'	; Output Decimal - Centenas
outD_DU	equ h'22'	; Output Decimal - Decenas /Unidades

varAux	equ h'30'
des		equ h'0A'
cen 	equ h'64' 

		ORG 0
		GOTO INICIO
		ORG 5

INICIO:	CLRF outD_C
		CLRF outD_DU
		CLRF varAux		
		MOVLW cen		

		CALL divPart
		ADDWF in_He,F
		MOVF varAux,W
		MOVWF outD_C
		CLRF varAux
		MOVLW des

		CALL divPart
		ADDWF in_He,F
		SWAPF varAux,W
		MOVWF outD_DU
		MOVF in_He,W
		ADDWF outD_DU
		GOTO$

divPart:SUBWF in_He,F		
		BTFSS STATUS,C	
		RETURN
		INCF varAux
		GOTO $-4

		END