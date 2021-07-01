  processor 16f877
  include<p16f877.inc>

;Variables para el DELAY
valor1 EQU h'21'
valor2 EQU h'22'
valor3 EQU h'23'
cte1 EQU 10h 
cte2 EQU 50h
cte3 EQU 60h

v0 EQU h'24'  
v1 EQU h'25'
v2 EQU h'26'
v3 EQU h'27'
v4 EQU h'29'
v5 EQU h'30'

c0 EQU 0h 
c1 EQU 1h
c2 EQU 2h
c3 EQU 3h 
c4 EQU 4h
c5 EQU 5h
  
  org 0h
  goto INICIO
  org 05h

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
CICLO:      
       movlw c0
       movwf v0
       movfw PORTA     ;Mueve lo que hay en PORTA a W
       xorwf v0,w      ;Verifica si la entrada es $00
       btfsc STATUS,Z  ;z=0?
       goto APG        ;NO, entonces v0=W
                       ;SI, entonves v0!=W
       movlw c1
       movwf v1
       movfw PORTA
       xorwf v1,w      ;Verifica si la entrada es $01
       btfsc STATUS,Z
       goto UNOS
       
       movlw c2
       movwf v2
       movfw PORTA
       xorwf v2,w      ;Verifica si la entrada es $02
       btfsc STATUS,Z
       goto DER

       movlw c3
       movwf v3
       movfw PORTA
       xorwf v3,w      ;Verifica si la entrada es $03
       btfsc STATUS,Z
       goto  IZQ
       
       movlw c4
       movwf v4
       movfw PORTA
       xorwf v4,w      ;Verifica si la entrada es $04
       btfsc STATUS,Z
       goto DERIZQ

ENCAPG:
	   movlw c5
       movwf v5
	   movfw PORTA
       xorwf v5,w      ;Verifica si la entrada es $05
       btfss STATUS,Z 
	   goto APG
       movlw h'00'     
       movwf PORTB     
       call retardo
       movlw h'FF'
       movwf PORTB     
       call retardo
       goto CICLO
APG:                   ;Apaga los bits del puerto B
       movlw h'00'
       movwf PORTB     
       goto CICLO
UNOS:                  ;Enciende los bits del puerto B
       movlw h'FF'     
       movwf PORTB
       goto CICLO
DER:                   ;Realiza corrimiento a la derecha
       movlw h'80'
       movwf PORTB
       call retardo
DER1:
       rrf PORTB,1
       call retardo
       btfss PORTB,0
       goto DER1
       goto CICLO
IZQ:                   ;Realiza corrimiento a la izquierda
       movlw h'01'
       movwf PORTB
       call retardo
IZQ1:
       rlf PORTB,1
       call retardo
       btfss PORTB,7
       goto IZQ1
       goto CICLO
DERIZQ:                ;Realiza corrimiento a la derecha y
       movlw h'80'     ;luego a la izquierda
       movwf PORTB
       call retardo
DER2:
       rrf PORTB,1
       call retardo
       btfss PORTB,0
       goto DER2
 
       movlw h'01'
       movwf PORTB
       call retardo
IZQ2:
       rlf PORTB,1
       call retardo
       btfss PORTB,7
       goto IZQ2
       goto CICLO       

       
retardo 
     movlw cte1      ;Rutina que genera un DELAY
     movwf valor1
tres movwf cte2
     movwf valor2
dos  movlw cte3
     movwf valor3
uno  decfsz valor3 
     goto uno 
     decfsz valor2
     goto dos
     decfsz valor1   
     goto tres
     return
     end