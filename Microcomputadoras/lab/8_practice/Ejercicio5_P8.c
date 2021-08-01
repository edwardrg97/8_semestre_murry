#include <16F877.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#define use_portb_lcd true //Definir puerto de uso para el LCD
#include <lcd.c>//Biblioteca para el manejo de LCD
void main() {
   lcd_init();//Inicialización LCD
   while( TRUE ) {
      lcd_gotoxy(1,1);//Posición LCD Renglon 1, Columna 1
      printf(lcd_putc," UNAM \n ");//Impresión de Mensaje
      lcd_gotoxy(1,2);//Posición LCD Renglon 2, Columna 1
      printf(lcd_putc," FI \n ");//Impresión de Mensaje
      delay_ms(300);//Retardo
   }
}
