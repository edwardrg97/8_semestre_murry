PROCESSOR 16f877
		INCLUDE <p16f877.inc>
J equ 	H'26'
K equ 	H'27'
C1 equ 	H'28'
R1 equ 	H'29'
		ORG 0
		GOTO INICIO
		ORG 5
INICIO:	MOVF J,W	;Dato en J mover a W.
		ADDWF K,0	;Sumar W con K y se guarda en W
		MOVWF R1	;Mover valor w a R1
		CLRF C1		;Limpiar C1
		BTFSS H'03',0 ;Banderas en dirección H'03' 
		;Si está levantado el bit en posición 0.
		GOTO FIN	;Si no se cumple ir a fin
		MOVLW H'01'	; si se cumple mover el valor 01 a W
		MOVWF C1	;Mover W a C1
FIN:	GOTO INICIO
		END