processor 16f877
include<p16f877.inc>

;Variables para el DELAY
valor1 equ h'21'
cte1 equ 10h 

aux equ 22h
  
		ORG 0
		GOTO INICIO
		ORG 5

INICIO:
		CLRF PORTA ;Algoritmo para generar los registros analógicos.
		CLRF PORTB
		BSF STATUS,RP0  ;Cambio al Banco 1
		BCF STATUS,RP1             
		MOVLW 00h       ;Configura puertos A y E como analógicos 00->analógicos
		MOVWF ADCON1 
		
		MOVLW 3fh       ;Configura el Puerto A como entrada->Potenciómetros
		MOVWF TRISA
		MOVLW h'00'
		MOVWF TRISB     ;Configura Puerto B como salida->LEDS
		CLRF  PORTB      ;Limpia los bits de Puerto 1
		BCF STATUS,RP0  ;Regresa al Banco 0
		MOVLW B'11000001' ;Configuración del registro analógico
							;Se configura el canal 0->11-000-0-1
		MOVWF ADCON0

LECTURA: 
		BSF ADCON0,2
		CALL RETARDO

ESPERA: 
		BTFSC ADCON0,2
       	GOTO ESPERA
		
		MOVF  ADRESH,0
		MOVWF aux
		MOVLW 33h
		SUBWF aux		
		BTFSS STATUS,C	;W > .99 
		GOTO SALIDA1	;W < .99
		
		MOVF  ADRESH,0
		MOVWF aux
		MOVLW 66h
		SUBWF aux		
		BTFSS STATUS,C	;W > 1.99 
		GOTO SALIDA2	;W < 1.99

		MOVF  ADRESH,0
		MOVWF aux
		MOVLW 99h
		SUBWF aux		
		BTFSS STATUS,C	;W > 2.99 
		GOTO SALIDA3		;W < 2.99


		MOVF  ADRESH,0
		MOVWF aux
		MOVLW h'CC'
		SUBWF aux		
		BTFSS STATUS,C	;W > 3.99 
		GOTO SALIDA4	;W < 3.99


		MOVF  ADRESH,0
		MOVWF aux
		MOVLW H'F5'
		SUBWF aux		
		BTFSS STATUS,C	;W > 4.80
		GOTO SALIDA5	;W < 4.8
		GOTO SALIDA6	;W<5

		
SALIDA1:
		MOVLW B'00111111'	; PUERTOB=0
		MOVWF PORTB
		GOTO LECTURA

SALIDA2:
		MOVLW B'00000110'	; PUERTOB=1
		MOVWF PORTB
		GOTO LECTURA
       
SALIDA3:
		MOVLW B'01011011'	; PUERTOB=2
		MOVWF PORTB
		GOTO LECTURA

SALIDA4:
		MOVLW B'01001111'	; PUERTOB=3
		MOVWF PORTB
		GOTO LECTURA     

SALIDA5:
		MOVLW B'01100110'	; PUERTOB=4
		MOVWF PORTB
		GOTO LECTURA

SALIDA6:
		MOVLW B'01101101'	; PUERTOB=5
		MOVWF PORTB
		GOTO LECTURA
         
RETARDO 
     	MOVLW cte1      ;Rutina que genera un DELAY
     	MOVWF valor1
UNO  
		DECFSZ valor1
     	GOTO UNO 
     	RETURN
		
		END