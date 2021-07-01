		processor 16f877a
		include <p16f877a.inc>

val		EQU h'20'
cal1    EQU h'21'
cal2    EQU h'22'
cal3	EQU h'23'
		ORG 0
		GOTO inicio
		ORG 5		
inicio:
		CLRF cal1
		CLRF cal2
		CLRF cal3
		CLRF PORTA			;Puerto a Entrada
		CLRF PORTB			;Puerto b Salida
		BSF STATUS, RP0
		BCF STATUS, RP1
		MOVLW 00h		; Configuración de ADFM y los puertos para el convertidor
		MOVWF ADCON1	; Convertidor
		CLRF TRISB
		BCF STATUS, RP0; vuelve al puerto cero

ciclo:
		CALL Lector1
		CALL Lector2
		CALL Lector3
		CALL compara
		GOTO ciclo
Lector1:
		MOVLW b'11000001'	;CANAL 0 DE ENTRADA
		MOVWF ADCON0		
		BSF ADCON0, 2		;INICIA EL PROCESO DE CONVERSIÓN
		CALL retardo		;RETARDO DE 20 

espera1:
		BTFSC ADCON0,2		; pregunta si termino conversion 
		GOTO espera1		; si no se cumple vuelve a espera y pregunta de nuevo
		MOVF ADRESH,w		; W=ADRESH
		MOVWF cal1			; CAL1=W
		RETURN

Lector2: 
		MOVLW b'11001001'	;CANAL 1 DE ENTRADA
		MOVWF ADCON0
		BSF ADCON0, 2		;CONVERSIÓN
		CALL retardo		;RETARDO

espera2:
		BTFSC ADCON0,2		; pregunta si termino conversion 
		GOTO espera2		; si no se cumple vuelve a espera y pregunta de nuevo
		MOVF ADRESH,w		; W=ADRESH
		MOVWF cal2			; CAL2=W
		RETURN

Lector3: 
		MOVLW b'11010001'
		MOVWF ADCON0
		BSF ADCON0, 2
		CALL retardo

espera3:
		BTFSC ADCON0,2		; pregunta si termino conversion 
		GOTO espera3		; si no se cumple vuelve a espera y pregunta de nuevo
		MOVF ADRESH,w		; W=ADRESH
		MOVWF cal3			; CAL3=W
		RETURN 


retardo:; retardo de 20 microseg
		MOVLW 0x20
		MOVWF val
uno 
		DECFSZ val
		GOTO uno
		RETURN

compara:			;COMPARACIÓN ENTRE LA SEÑAL 1> SEÑAL 2 Y 3
		MOVF cal2,w
		SUBWF cal1,w
		BTFSS STATUS,0
		GOTO compara2

		MOVF cal3,w
		SUBWF cal1,w
		BTFSS STATUS,0
		GOTO compara3

		MOVLW 0X01		;Si señal 1 es mayor salida 01
		MOVWF PORTB
		RETURN

compara2:			;COMPARACIÓN ENTRE LA SEÑAL 2> SEÑAL 1 Y 3
		MOVF  cal1,w
		SUBWF cal2,w
		BTFSS STATUS,0
		GOTO compara

		MOVF cal3,w
		SUBWF cal2,w
		BTFSS STATUS,0
		GOTO compara3

		MOVLW 0X03			;Si señal 1 es mayor salida 01
		MOVWF PORTB
		GOTO ciclo

compara3:			;COMPARACIÓN ENTRE LA SEÑAL 3> SEÑAL 1 Y 2
		MOVF cal1,w
		SUBWF cal3,w
		BTFSS STATUS,0
		GOTO compara2

		MOVF cal2,w
		SUBWF cal3,w
		BTFSS STATUS,0
		GOTO compara3

		MOVLW 0x07			;Si señal 1 es mayor salida 01
		MOVWF PORTB
		GOTO ciclo

	END
