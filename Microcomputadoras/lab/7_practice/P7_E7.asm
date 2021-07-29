		processor 16f877
		include<p16f877.inc>

;Variables para el DELAY
TEMP	EQU H'30'
B_TEMP	EQU H'31'
CONT	EQU	h'32'
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 50h
cte2 equ 50h
cte3 equ 60h

  		ORG 0  		
		GOTO INICIO
  		ORG 5
INICIO:
		;Configuración Convertidor A/D
		CLRF PORTA ;Algoritmo para generar los registros analógicos.
		BSF STATUS,RP0  ;Cambio al Banco 1
		BCF STATUS,RP1

		MOVLW 00h       ;Configura puertos A y E como analógicos 00->analógicos
		MOVWF ADCON1 
		
		BCF STATUS,RP0
		
		MOVLW B'11000001' ;Configuración del registro analógico
       					;Se configura el canal 0->
						;Frecuencia del reloj:11
						;CHS2-0:000
						;GO/DONE:0 Termina la conversión
						;-:0
						;adon:0 enciende el convertidor
							
		MOVWF ADCON0		;Asigna la conf. al adcon0

		;Configuración Comunicación

		BSF STATUS,RP0  ;Cambio al Banco 1
		BCF STATUS,RP1

		BSF TXSTA,BRGH
		MOVLW D'129'

		MOVWF SPBRG			;Asignar 9600 BAUDS
		
		BCF TXSTA,SYNC		;Modo de comunicación=0. Asíncrona
		BSF TXSTA,TXEN		;Activación de transmisión
		
		BCF STATUS,RP0	;Cambio al banco 0
		
		BSF RCSTA,SPEN		;Habilita el puerto Serie
		BSF RCSTA,CREN		;Activa la recepción continua en modo de comunicación asíncrona

		CLRF TEMP
		CLRF B_TEMP
		
		MOVLW	H'70'
		MOVWF	CONT
		
		
		
LECTURA
		BSF	ADCON0,2
		CALL RETARDO

ESPERA: 
		CLRF	TEMP
		CLRF	B_TEMP
		BTFSC 	ADCON0,2	;Si está prendido el convertidor 
       	GOTO 	ESPERA
		MOVF 	ADRESH,W	;Registro de los resultados en la parte alta
		MOVWF	TEMP

		CALL	COMP_CENT
		CALL	COMP_DEC
		CALL	COMP_UNI
		CALL	FORM
		CALL	FORM_C
		CALL	ENTER
		CALL	RETARDO
		DECFSZ	CONT
		GOTO 	LECTURA
		GOTO 	LOOP

LOOP
		GOTO LOOP
FORM
		MOVLW	H'F8'
		GOTO	CONF

FORM_C
		MOVLW	A'C'
		GOTO	CONF

ENTER	
		MOVLW	H'0D'
		GOTO 	CONF

COMP_CENT
		MOVLW	0X33
		SUBWF	TEMP,0
		BTFSS	STATUS,C
		GOTO	CIEN_0
		GOTO	CIEN_1

;Comparación Decenas
COMP_DEC
		MOVLW	0X05
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO 	ZERO

		MOVLW	0X0A
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	ONE
		
		MOVLW	0X0F
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	TWO		
		
		MOVLW	0X14
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	THREE

		MOVLW	0X19
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	FOUR

		MOVLW	0X1E
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	FIVE

		MOVLW	0X24
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	SIX

		MOVLW	0X29
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO	SEVEN

		MOVLW	0X2E
		SUBWF	TEMP,W
		BTFSS	STATUS,C
		GOTO 	EIGHT

		GOTO 	NINE

		
;Comparación unidades
COMP_UNI
				
		
		MOVLW	0X04
		XORWF	TEMP,W
		BTFSC	STATUS,Z
		GOTO	EST_8_9

		MOVLW	0X03
		XORWF	TEMP,W
		BTFSC	STATUS,Z
		GOTO	EST_6_7

		MOVLW	0X02
		XORWF	TEMP,W
		BTFSC	STATUS,Z
		GOTO	EST_4_5

		MOVLW	0X01
		XORWF	TEMP,W
		BTFSC	STATUS,Z
		GOTO	EST_2_3

		GOTO	EST_0_1
;Revisar parte baja para unidades
EST_8_9
		BSF STATUS,RP0  ;Cambio al Banco 1
		MOVF	ADRESL,W
		MOVWF	B_TEMP
		SWAPF	B_TEMP
		RRF		B_TEMP
		RRF		B_TEMP		
		BTFSS	B_TEMP,1
		GOTO	EIGHT
		GOTO	NINE
EST_6_7
		BSF STATUS,RP0  ;Cambio al Banco 1
		MOVF	ADRESL,W
		MOVWF	B_TEMP
		SWAPF	B_TEMP
		RRF		B_TEMP
		RRF		B_TEMP		
		BTFSS	B_TEMP,1
		GOTO	SIX
		GOTO	SEVEN
EST_4_5
		BSF STATUS,RP0  ;Cambio al Banco 1
		MOVF	ADRESL,W
		MOVWF	B_TEMP
		SWAPF	B_TEMP
		RRF		B_TEMP
		RRF		B_TEMP		
		BTFSS	B_TEMP,1
		GOTO	FOUR
		GOTO	FIVE
EST_2_3
		BSF STATUS,RP0  ;Cambio al Banco 1
		MOVF	ADRESL,W
		MOVWF	B_TEMP
		SWAPF	B_TEMP
		RRF		B_TEMP
		RRF		B_TEMP		
		BTFSS	B_TEMP,1
		GOTO	TWO
		GOTO	THREE
EST_0_1
		BSF STATUS,RP0  ;Cambio al Banco 1
		MOVF	ADRESL,W
		MOVWF	B_TEMP
		SWAPF	B_TEMP
		RRF		B_TEMP
		RRF		B_TEMP		
		BTFSS	B_TEMP,1
		GOTO	ZERO
		GOTO	ONE

CIEN_1
		MOVLW 	0X33
		SUBWF	TEMP
		MOVLW	A'1'
		GOTO	CONF
CIEN_0
		MOVLW	A'0'
		GOTO	CONF

NINE
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X2E
		SUBWF	TEMP,1
		MOVLW	A'9'
		GOTO	CONF
		
EIGHT
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X29
		SUBWF	TEMP,1
		MOVLW	A'8'
		GOTO	CONF
SEVEN
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X24
		SUBWF	TEMP,1
		MOVLW	A'7'
		GOTO	CONF
SIX
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X1E
		SUBWF	TEMP,1
		MOVLW	A'6'
		GOTO	CONF
FIVE
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X19
		SUBWF	TEMP,1
		MOVLW	A'5'
		GOTO	CONF
FOUR
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X14
		SUBWF	TEMP,1
		MOVLW	A'4'
		GOTO	CONF
THREE
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X0F
		SUBWF	TEMP,1
		MOVLW	A'3'
		GOTO	CONF
TWO
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X0A
		SUBWF	TEMP,1
		MOVLW	A'2'
		GOTO	CONF
ONE
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW 	0X05
		SUBWF	TEMP,1
		MOVLW	A'1'
		GOTO	CONF
ZERO
		BCF STATUS,RP0  ;Cambio al Banco 0
		MOVLW	A'0'
		GOTO	CONF

CONF
	MOVWF	TXREG
	BSF		STATUS,RP0		;Cambio al banco 1

TRANSMITIR
	BTFSS	TXSTA,TRMT		;Revisión de transmisión exitosa
	GOTO	TRANSMITIR
	BCF		STATUS,RP0		;Cambio al banco 0
	RETURN					;Regreso al último CALL

RETARDO
			; retardo de 20 microseg
		MOVLW 0x20
		MOVWF valor1
uno 
		DECFSZ valor1
		GOTO uno
		RETURN
	END