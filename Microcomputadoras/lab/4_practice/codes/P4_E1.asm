

processor 16f877 ;Indica la versión de procesador
	 include <p16f877.inc> ;Incluye la librería de la versión del procesador

valor1 	EQU h'21'	;valor1=h'21'
valor2 	EQU h'22'	;valor2=h'22'
valor3 	EQU h'23'	;valor3=h'23'
cte1 	EQU 30h 
cte2 	EQU 50h
cte3 	EQU 60h

		ORG 0 ;Carga al vector de RESET la dirección de inicio
	 	GOTO INICIO
	 	ORG 05 ;Dirección de inicio del programa del usuario	 
INICIO:
		CLRF PORTA
		BSF STATUS,RP0 ;Cambia la banco 1
		BCF STATUS,RP1
		MOVLW 07H ;Configura puertos A y E como digitales
		MOVWF ADCON1
		MOVLW 3FH ;Configura el puerto A como entrada
		MOVWF TRISA
	 	
       	MOVLW h'0'
       	MOVWF TRISB     ;Configura el puerto B como salida
       	BCF STATUS,5    ;Cambio BANCO 0
       	CLRF PORTB      ;Limpia los bits del PUERTO B
       
LOOP2:
		BTFSC 	PORTA,0		;Revisa si el bit 0 del puerto a esta en 0
		GOTO	ENCENDER	;Si no es asi, llama a subrutina de encendido
       	GOTO	APAGAR		;Si es asi, llama a la subrutina de apagado
      
 
ENCENDER:
		MOVLW 	H'FF'     ;Cargamos a w el valor de FFh=11111111b
    	MOVWF	PORTB     ;Esto nos permitira encender todos los bits
                       ;del puerto B
		GOTO	LOOP2
APAGAR:
		CLRF 	PORTB 		;Limpia el puerto B
        GOTO 	LOOP2	

		end