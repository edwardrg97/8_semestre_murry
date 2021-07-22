; ALUMNO: Alfonso Murrieta Villegas
; Proyecto 1: Puertos paralelos 

PROCESSOR 	16f877
INCLUDE		<p16f877.inc>

AUX		EQU	H'50'
COUNT	EQU	H'51'
INPUT	EQU	H'20'
INPUT1	EQU H'21'
INPUT2	EQU H'22'
FIN		EQU	H'23'
DATA_INF	EQU H'24'	
SPC_PT	EQU	0X20

NUM_HEX		EQU	H'30'
DATA_C_HX	EQU	H'31'
AUX_IN_C	EQU	H'32'	
AUX_IN_D	EQU	H'33'	
AUX_IN_U	EQU	H'34'	
AUX_TP_HX	EQU	H'36'
AUX_SB_HX	EQU	H'37'


	ORG 	0
	GOTO 	INICIO
  	ORG 	5


INICIO
	BSF		STATUS,RP0		
	BCF		STATUS,RP1		
	MOVLW	0X0F
	MOVWF	ADCON1			
	MOVLW	0X00		
	MOVWF	TRISB			
	MOVWF	TRISA			
	MOVLW	0X07
	MOVWF	TRISE			
	MOVLW	0XFF
	MOVWF	TRISC			
	BCF		STATUS,RP0	
	;DONT MOVE OR DELETE THIS	
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTC
	CLRF	PORTE
	CLRF	AUX_IN_C	
	CLRF	AUX_IN_D
	CLRF	AUX_IN_U
	CALL	DISP_IN




CHECK_CASE	; SWITCH MENU
	MOVLW	H'00'	
	XORWF	PORTE,W
	BTFSC	STATUS,Z
	GOTO	DATA_NAME
	MOVLW	H'01'
	XORWF	PORTE,W
	BTFSC	STATUS,Z
	GOTO	DC_DATA
	MOVLW	H'02'
	XORWF	PORTE,W
	BTFSC	STATUS,Z
	GOTO	HX_DATA
	MOVLW	H'03'
	XORWF	PORTE,W
	BTFSC	STATUS,Z
	GOTO	BIN_DATA
	MOVLW	H'04'
	XORWF	PORTE,W
	BTFSC	STATUS,Z
	GOTO	MAIN_FIGURE
	GOTO	CHECK_CASE
	




DATA_NAME					
	MOVLW	0X80		
	CALL 	DATA__AUX1
	CALL	CLS_DSP
	MOVLW	A'A'
	CALL	DATA_AUX2
	MOVLW	A'L'
	CALL	DATA_AUX2
	MOVLW	A'F'
	CALL	DATA_AUX2
	MOVLW	A'O'
	CALL	DATA_AUX2
	MOVLW	A'N'
	CALL	DATA_AUX2
	MOVLW	A'S'
	CALL	DATA_AUX2
	MOVLW	A'O'
	CALL	DATA_AUX2
	MOVLW	A' '
	CALL	DATA_AUX2
	MOVLW	A'M'
	CALL	DATA_AUX2
	MOVLW	A'U'
	CALL	DATA_AUX2
	MOVLW	A'R'
	CALL	DATA_AUX2
	MOVLW	A'R'
	CALL	DATA_AUX2
	MOVLW	A'I'
	CALL	DATA_AUX2
	MOVLW	A'E'
	CALL	DATA_AUX2
	MOVLW	A'T'
	CALL	DATA_AUX2
	MOVLW	A'A'
	CALL	DATA_AUX2
	GOTO	STP_DSP
DC_DATA	; INPUT TO DECIMAl
	MOVLW	0X80		
	CALL 	DATA__AUX1
	CLRF	AUX
	MOVF	PORTC,W
	MOVWF	NUM_HEX
	MOVWF	DATA_C_HX
	CALL	GET_DC
	CALL	SEND_N_C_D
	CALL	SEND_N_D_D
	CALL	SEND_N_U_D
	MOVLW	A' '
	CALL	DATA_AUX2
	MOVLW	A'D'
	CALL	DATA_AUX2
	MOVLW	0X09
	MOVWF	COUNT
	CALL	WHT_SPC
	MOVLW	0XC0
	CALL 	DATA__AUX1
	MOVLW	0X0F
	MOVWF	COUNT
	CALL	WHT_SPC
	GOTO 	CHECK_CASE
HX_DATA		;INPUT TO HEX
	MOVLW	0X80	
	CALL 	DATA__AUX1
	CLRF	AUX
	MOVF	PORTC,W
	MOVWF	NUM_HEX
	MOVWF	DATA_C_HX
	CALL	GET_T_HX
	CALL	DIV_AUX_TP_HX
	CALL	DIV_RS_HX
	MOVLW	A' '
	CALL	DATA_AUX2
	MOVLW	A'H'
	CALL	DATA_AUX2
	MOVLW	0X0A
	MOVWF	COUNT
	CALL	WHT_SPC
	MOVLW	0XC0
	CALL 	DATA__AUX1
	MOVLW	0X10
	MOVWF	COUNT
	CALL	WHT_SPC
	GOTO 	CHECK_CASE
BIN_DATA	;INPUT TO BIN
	MOVLW	0X80		
	CALL 	DATA__AUX1
	CLRF	AUX
	MOVF	PORTC,W
	MOVWF	NUM_HEX
	MOVWF	DATA_C_HX
	MOVLW	0X08
	MOVWF	COUNT
	CALL	GET_B
	MOVLW	A' '
	CALL	DATA_AUX2
	MOVLW	A'B'
	CALL	DATA_AUX2
	MOVLW	0X05
	MOVWF	COUNT
	CALL	WHT_SPC
	MOVLW	0XC0
	CALL 	DATA__AUX1
	MOVLW	0X10
	MOVWF	COUNT
	CALL	WHT_SPC
	GOTO 	CHECK_CASE
;DRAW CHR
MAIN_FIGURE
	MOVLW	0X80		
	CALL 	DATA__AUX1
	CALL	CLS_DSP
	CALL	PRINT_OBJ
	MOVLW	0X80
	CALL	DATA__AUX1
	MOVLW	H'00'
	CALL	DATA_AUX2
	MOVLW	H'01'
	CALL	DATA_AUX2
	MOVLW	0X0D
	MOVWF	COUNT	
	CALL	WHT_SPC
	MOVLW	0XC0
	CALL 	DATA__AUX1
	MOVLW	H'02'
	CALL	DATA_AUX2
	MOVLW	H'03'
	CALL	DATA_AUX2
	MOVLW	0X0D
	MOVWF	COUNT	
	CALL	WHT_SPC
	GOTO	STP_DSP





CLS_DSP		;CLEAN LCD			
	MOVLW	SPC_PT
	MOVLW	A' '
	CALL	DATA_AUX2
	DECFSZ	SPC_PT
	GOTO	CLS_DSP
	
	MOVLW	0X80		
	CALL 	DATA__AUX1
	RETURN
STP_DSP					
	MOVF	PORTE,W
	MOVWF	FIN
L_STP_DSP
	MOVF	PORTE,W
	XORWF	FIN,W
	BTFSS	STATUS,Z
	GOTO	CHECK_CASE
	GOTO	L_STP_DSP






GET_DC		;CONV AND SEND DEC	
	MOVLW	0X64		
	CALL DIV_DC		
	MOVF	AUX,W		
	MOVWF	AUX_IN_C	
GET_DC_DC
	MOVLW	0X0A		
	CLRF	AUX			
	CALL DIV_DC		
	MOVF	AUX,W		
	MOVWF	AUX_IN_D		
GET_U_DC
	MOVLW	0X01		
	CLRF	AUX			
	CALL DIV_DC
	MOVF	AUX,W			
	MOVWF	AUX_IN_U		
	RETURN
DIV_DC					
	SUBWF	NUM_HEX,F		
	BTFSS	STATUS,C		
	GOTO	AUX_FUNC			
	INCF	AUX							
	GOTO DIV_DC			
AUX_FUNC									
	ADDWF	NUM_HEX			
	RETURN
SEND_N_C_D					
	MOVF	AUX_IN_C,W
	MOVWF	AUX
	GOTO	PRINT_N
SEND_N_D_D					
	MOVF	AUX_IN_D,W
	MOVWF	AUX
	GOTO	PRINT_N	
SEND_N_U_D					
	MOVF	AUX_IN_U,W
	MOVWF	AUX
	GOTO	PRINT_N
GET_T_HX	;CONV AND SEND HEX
	MOVLW	0X04
	MOVWF	COUNT
GET_AUX_TP_HX_AUX					
	RRF		DATA_C_HX,F
	BCF		STATUS,C
	DECFSZ	COUNT
	GOTO	GET_AUX_TP_HX_AUX
	MOVF	DATA_C_HX,W
	MOVWF	AUX_TP_HX
	MOVLW	0X04
	MOVWF	COUNT
	MOVF	NUM_HEX,W
	MOVWF	DATA_C_HX
GET_S_H					
	RLF		DATA_C_HX,F
	BCF		STATUS,C
	DECFSZ	COUNT
	GOTO	GET_S_H
	SWAPF	DATA_C_HX
	MOVF	DATA_C_HX,W
	MOVWF	AUX_SB_HX
	RETURN
DIV_AUX_TP_HX					
	MOVF	AUX_TP_HX,W
	MOVWF	AUX
	GOTO	PRINT_N
DIV_RS_HX					
	MOVF	AUX_SB_HX,W
	MOVWF	AUX
	GOTO	PRINT_N
GET_B	;CONV AND SEND BIN	
	RLF		DATA_C_HX
	BTFSS	STATUS,C
	GOTO	C_B_0
	GOTO	C_B_1
C_B_0					
	CALL	NUM_0
	GOTO	GO_BN
C_B_1					
	CALL	NUM_1
	GOTO	GO_BN
GO_BN
	DECFSZ	COUNT
	GOTO	GET_B
	RETURN
	



;PRINT CASE 4
PRINT_OBJ
	MOVLW	0X40		
	CALL	DATA__AUX1
	MOVLW	B'00000'	; COOR 1
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00000'	; COOR 2
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'11110'
	CALL	DATA_AUX2
	MOVLW	B'11110'
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'00100'	; COOR 3
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00100'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'10010'	; COOR 4
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'10010'
	CALL	DATA_AUX2
	MOVLW	B'11110'
	CALL	DATA_AUX2
	MOVLW	B'11110'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	MOVLW	B'00000'
	CALL	DATA_AUX2
	RETURN





; SWITCH DATA
WHT_SPC
	MOVLW	A' '
	CALL	DATA_AUX2
	DECFSZ	COUNT
	GOTO	WHT_SPC
	RETURN
PRINT_N					
	MOVLW	0X00
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_0
	MOVLW	0X01
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_1	
	MOVLW	0X02
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_2
	MOVLW	0X03
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_3
	MOVLW	0X04
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_4
	MOVLW	0X05
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_5
	MOVLW	0X06
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_6
	MOVLW	0X07
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_7
	MOVLW	0X08
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_8
	MOVLW	0X09
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_9
	MOVLW	0X0A
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_A
	MOVLW	0X0B
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_B
	MOVLW	0X0C
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_C
	MOVLW	0X0D
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_D
	MOVLW	0X0E
	XORWF	AUX,W
	BTFSC	STATUS,Z
	GOTO	NUM_E
	GOTO	NUM_F	





; MENU PRINT DATA								
NUM_0
	MOVLW	A'0'
	CALL	DATA_AUX2
	RETURN
NUM_1
	MOVLW	A'1'
	CALL	DATA_AUX2
	RETURN
NUM_2
	MOVLW	A'2'
	CALL	DATA_AUX2
	RETURN
NUM_3
	MOVLW	A'3'
	CALL	DATA_AUX2
	RETURN
NUM_4
	MOVLW	A'4'
	CALL	DATA_AUX2
	RETURN
NUM_5
	MOVLW	A'5'
	CALL	DATA_AUX2
	RETURN
NUM_6
	MOVLW	A'6'
	CALL	DATA_AUX2
	RETURN
NUM_7
	MOVLW	A'7'
	CALL	DATA_AUX2
	RETURN
NUM_8
	MOVLW	A'8'
	CALL	DATA_AUX2
	RETURN
NUM_9
	MOVLW	A'9'
	CALL	DATA_AUX2
	RETURN
NUM_A
	MOVLW	A'A'
	CALL	DATA_AUX2
	RETURN
NUM_B
	MOVLW	A'B'
	CALL	DATA_AUX2
	RETURN
NUM_C
	MOVLW	A'C'
	CALL	DATA_AUX2
	RETURN
NUM_D
	MOVLW	A'D'
	CALL	DATA_AUX2
	RETURN
NUM_E
	MOVLW	A'E'
	CALL	DATA_AUX2
	RETURN
NUM_F
	MOVLW	A'F'
	CALL	DATA_AUX2
	RETURN	





;SETTINGS FOR DISPLAY
DISP_IN
	MOVLW	0X30		
	CALL	DATA__AUX1
	CALL 	WAIT_PRINT_2
	MOVLW	0X30		
	CALL	DATA__AUX1
	CALL	WAIT_PRINT_2
	MOVLW	0X38		
	CALL	DATA__AUX1
	MOVLW	0X0C		
	CALL	DATA__AUX1
	MOVLW	0X01		
	CALL 	DATA__AUX1
	MOVLW	0X06		
	CALL 	DATA__AUX1
	MOVLW	0X02		
	CALL 	DATA__AUX1	
	RETURN	
DATA__AUX1
	MOVWF	PORTB
	CALL	WAIT_PRINT_1
	MOVLW	H'02'		
	MOVWF	PORTA		
	CALL	WAIT_PRINT_1
	MOVLW	H'00'
	MOVWF	PORTA		
	CALL	WAIT_PRINT_1
	CALL	WAIT_PRINT_1
	RETURN
DATA_AUX2						
	MOVWF	PORTB
	CALL	WAIT_PRINT_1
	MOVLW	H'03'		
	MOVWF	PORTA
	CALL	WAIT_PRINT_1
	MOVLW	H'01'		
	MOVWF	PORTA
	CALL	WAIT_PRINT_1
	CALL	WAIT_PRINT_1
	RETURN
WAIT_PRINT_1				
	MOVLW	0X02
	MOVWF	INPUT1
LOOP
	MOVLW	D'164'
	MOVFW	INPUT2
LOOP1
	DECFSZ	INPUT2
	GOTO	LOOP1
	DECFSZ	INPUT1
	GOTO	LOOP
	RETURN
WAIT_PRINT_2				
	MOVLW	0X03
	MOVWF	INPUT
AUX_3
	MOVLW	0XFF
	MOVWF	INPUT1
AUX_2	
	MOVLW	0XFF
	MOVWF	INPUT2
AUX_1
	DECFSZ	INPUT2
	GOTO	AUX_1
	DECFSZ	INPUT1
	GOTO	AUX_2
	DECFSZ	INPUT
	GOTO	AUX_3
	RETURN
	END