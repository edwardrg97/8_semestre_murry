	PROCESSOR 16f877
	INCLUDE <p16f877.inc>
K equ H'26'
L equ H'27'	

	ORG 0
	GOTO INICIO

	ORG 5
INICIO: MOVLW H'05'
	 ADDWF K,0
	 MOVWF L
	 GOTO INICIO
END