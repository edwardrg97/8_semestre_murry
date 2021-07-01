	processor 16f877
  	include<p16f877.inc>

valor1 equ h'21'	;equivalencia
valor2 equ h'22'
valor3 equ h'23'
					
giroder	equ h'24'	;Contadores de giros
giroizq	equ h'25'

giroderTop equ h'26'	;Topes de giros
giroizqTop equ h'27'

cte1 equ 70h		;Retardo normal
cte2 equ 70h
cte3 equ 70h
	
cte1_5 equ 0xff		;Retardo de 5 segundos
cte2_5 equ 0xff
cte3_5 equ 0x7f
					;Retardo de 10 segundos
cte1_10 equ 0xff
cte2_10 equ 0xff
cte3_10 equ 0xff


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
       movlw 0x3f      ;Configura el Puerto A como entrada
       movwf TRISA
       bcf STATUS,RP0  ;Regresa al Banco 0
 
       
LOOP:
	CLRF  giroder
	CLRF  giroizq     
	MOVF PORTA,W	;w<--PORTA
	ANDLW 0X0F 	;W<--PORTA & 00000111
	ADDWF PCL,F			;PCL<--PORTA & 00000111
	GOTO CONF0			;PC+0
	GOTO CONF1			;PC+1
	GOTO CONF2			;PC+2
	GOTO CONF3			;PC+3
	GOTO CONF4			;PC+4

CONF0:
	MOVLW 0X00
	MOVWF PORTB
	GOTO LOOP
CONF1:				;derecho
	MOVLW 0X0C
	MOVWF PORTB
	CALL RETARDO_1
	MOVLW 0X06
	MOVWF PORTB
	CALL RETARDO_1
	MOVLW 0X03
	MOVWF PORTB
	CALL RETARDO_1
	MOVLW 0X09
	MOVWF PORTB
	CALL RETARDO_1
	GOTO LOOP
CONF2:				;izquierdo
	MOVLW 0X09
	MOVWF PORTB
	CALL RETARDO_2
	MOVLW 0X03
	MOVWF PORTB
	CALL RETARDO_2
	MOVLW 0X06
	MOVWF PORTB
	CALL RETARDO_2
	MOVLW 0X0C
	MOVWF PORTB
	CALL RETARDO_2
	GOTO LOOP
CONF3:				;derecho
	
	MOVLW 0X0C
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X06
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X03
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X09
	MOVWF PORTB
	CALL RETARDO


	INCF giroder
	MOVLW 0X05
	MOVWF giroderTop
	MOVF giroder,W
	XORWF giroderTop
	BTFSC STATUS,2
	GOTO RETARDO_SPACE
	GOTO CONF3
	
	
CONF4:				;izquierdo
	MOVLW 0X09
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X03
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X06
	MOVWF PORTB
	CALL RETARDO
	MOVLW 0X0C
	MOVWF PORTB
	CALL RETARDO

	INCF giroizq
	MOVLW 0X0A
	MOVWF giroizqTop
	MOVF giroizq,W
	XORWF giroizqTop
	BTFSC STATUS,2
	GOTO RETARDO_SPACE
	GOTO CONF4
	

RETARDO ;retardo de tres niveles
	MOVLW cte1
	MOVWF valor1
tres MOVLW cte2
	MOVWF valor2
dos MOVLW cte3
	MOVWF valor3
uno DECFSZ valor3 ;desincrementa valor 3
	GOTO uno
	DECFSZ valor2 ;desincrementa valor 3
	GOTO dos
	DECFSZ valor1 ;desincrementa valor 3
	GOTO tres
	RETURN

RETARDO_SPACE ;retardo de tres niveles
	MOVLW cte1_5
	MOVWF valor1
tres_s
	MOVLW cte2_5
	MOVWF valor2
dos_s
	MOVLW cte3_5
	MOVWF valor3
uno_s 
	DECFSZ valor3 ;desincrementa valor 3
	GOTO uno_s
	DECFSZ valor2 ;desincrementa valor 3
	GOTO dos_s
	DECFSZ valor1 ;desincrementa valor 3
	GOTO tres_s
	GOTO LOOP

RETARDO_1 ;retardo de tres niveles
	MOVLW cte1_5
	MOVWF valor1
tres_1 
	MOVLW cte2_5
	MOVWF valor2
dos_1 
	MOVLW cte3_5
	MOVWF valor3
uno_1 
	DECFSZ valor3 ;desincrementa valor 3
	GOTO uno_1
	DECFSZ valor2 ;desincrementa valor 3
	GOTO dos_1
	DECFSZ valor1 ;desincrementa valor 3
	GOTO tres_1
	RETURN


RETARDO_2   ;retardo de tres niveles
	MOVLW cte1_10
	MOVWF valor1
tres_2
	MOVLW cte2_10
	MOVWF valor2
dos_2 
	MOVLW cte3_10
	MOVWF valor3
uno_2 
	DECFSZ valor3 ;desincrementa valor 3
	GOTO uno_2
	DECFSZ valor2 ;desincrementa valor 3
	GOTO dos_2
	DECFSZ valor1 ;desincrementa valor 3
	GOTO tres_2
	RETURN

	END