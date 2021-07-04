		processor 16f877
		include<p16f877.inc>

;Variables para el DELAY
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h 
cte2 equ 50h
cte3 equ 60h

  		ORG 0  		
		GOTO INICIO
  		ORG 5
INICIO:
       CLRF PORTA ;Algoritmo para generar los registros analógicos.
       CLRF PORTE
       BSF STATUS,RP0  ;Cambio al Banco 1
       BCF STATUS,RP1
       MOVLW 00h       ;Configura puertos A y E como analógicos 00->analógicos
       MOVWF ADCON1 
	
	   MOVLW 3fh       ;Configura el Puerto A como entrada->Potenciómetros
       MOVWF TRISA
       MOVLW h'00'
       MOVWF TRISB     ;Puerto B como salida
       CLRF PORTB      ;Limpieza bits de Puerto B
       BCF STATUS,RP0  ;Regresa al Banco 0
       MOVLW B'11000001' ;Configuración del registro analógico
       					;Se configura el canal 0->
						;Frecuencia del reloj:11
						;CHS2-0:000
						;GO/DONE:0 Termina la conversión
						;-:0
						;adon:0 enciende el convertidor
							
       MOVWF ADCON0		;Asigna la conf. al adcon0

LECTURA: 
		BSF ADCON0,2	;Enciende el proceso de conversión
		CALL RETARDO

ESPERA: 
		BTFSC ADCON0,2	;Si está prendido el convertidor 
       	GOTO ESPERA
		MOVF ADRESH,W	;Registro de los resultados en la parte alta
		MOVWF PORTB		;Lanza adresh al puerto B
       	GOTO LECTURA	
       
         
RETARDO:
     	MOVLW cte1      ;Rutina que genera un DELAY
     	MOVWF valor1
ONE
		DECFSZ valor1
    	GOTO ONE 
     	RETURN
		
		END