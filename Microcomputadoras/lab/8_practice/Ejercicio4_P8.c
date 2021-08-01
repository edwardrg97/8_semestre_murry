#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
//Configuración de la comunicación serial con la terminal
#org 0x1F00, 0x1FFF void loader16F877(void) {}
void main(){
   while(1){
      output_b(0xff); //Salida por Puerto B
      printf(" Todos los bits encendidos \n\r");
      //Impresión de texto a la terminal
      delay_ms(1000);//Redardo
      output_b(0x00); //Salida por puerto B
      printf(" Todos los leds apagados \n\r");
      //Impresión de texto a la terminal
      delay_ms(1000);//Retardo
   }//while
}//main
