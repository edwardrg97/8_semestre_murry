 		processor 16f877
  		include<p16f877.inc>

 		org 0
 		goto INICIO
  		org 5

INICIO:
       clrf PORTA
       bsf STATUS,RP0  ;Cambio al Banco 1
       bcf STATUS,RP1 
       movlw h'0'
       movwf TRISB     ;Configura Puerto B como salida
       clrf PORTB      ;Limpia los bits de Puerto 1
            
       movlw 06h       ;Configura puertos A y E como digitales
       movwf ADCON1 
       movlw 3fh       ;Configura el Puerto A como entrada
       movwf TRISA
       bcf STATUS,RP0  ;Regresa al Banco 0
 
       
LOOP:     
	MOVF PORTA,W	;w<--PORTA
	ANDLW 0X0F 	;W<--PORTA & 00000111
	ADDWF PCL,F			;PCL<--PORTA & 00000111
	GOTO CONF0			;PC+0
	GOTO CONF1			;PC+1
	GOTO CONF2			;PC+2
	GOTO CONF3			;PC+3
	GOTO CONF4			;PC+4
	GOTO CONF5			;PC+5
	GOTO CONF6			;PC+6
	GOTO CONF7			;PC+7
	GOTO CONF8			;PC+8

CONF0:				;PARO PARO
	MOVLW 0X00
	MOVWF PORTB
	GOTO LOOP
CONF1:				;PARO horario
	MOVLW 0X06
	MOVWF PORTB
	GOTO LOOP
CONF2:				;PARO ANTIHORIO
	MOVLW 0X05
	MOVWF PORTB
	GOTO LOOP
CONF3:				;HORARIO PARO
	MOVLW 0X30
	MOVWF PORTB
	GOTO LOOP
CONF4:				;ANTIHORARIO PARO
	MOVLW 0X28
	MOVWF PORTB
	GOTO LOOP
CONF5:				;HORARIO HORARIO
	MOVLW 0X36
	MOVWF PORTB
	GOTO LOOP
CONF6:				;antihorario antihorario
	MOVLW 0X2D
	MOVWF PORTB
	GOTO LOOP
CONF7:				;horario antihorario
	MOVLW 0X35
	MOVWF PORTB
	GOTO LOOP
CONF8:				;ANTIHORARIO HORARIO
	MOVLW 0x2E
	MOVWF PORTB
	GOTO LOOP
	

	END