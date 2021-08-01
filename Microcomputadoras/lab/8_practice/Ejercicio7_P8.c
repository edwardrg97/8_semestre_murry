#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#define use_portb_lcd true
#include <lcd.c>//Manejo del LCD

#org 0x1F00, 0x1FFF void loader16F877(void) {} 

long push_button=0;
void main() {
   lcd_init();//Inicialización LCD
   set_tris_a(0xFF);//A como entrada
   while(1) {
      if(input(PIN_A0)==0){//Caso del boton oprimido
         push_button++;    //Sumar 1 a las veces presionado

      }
      lcd_gotoxy(5,1);//Posición LCD Renglon 1, Columna 1
      printf(lcd_putc,"%04ld\n",push_button);//Impresión de Mensaje
      lcd_gotoxy(5,2);//Posición LCD Renglon 2, Columna 1
      printf(lcd_putc,"%04lX\n",push_button);//Impresión de Mensaje
      delay_ms(300);//Retardo
   }
}
