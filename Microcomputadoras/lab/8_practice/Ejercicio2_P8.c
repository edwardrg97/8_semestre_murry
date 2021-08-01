#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#org 0x1F00, 0x1FFF void loader16F877(void) {}
void main(){
   while(1){
      output_b(0xFF);   //Salida de 0xFF por puerto B
      delay_ms(1000);   //Retardo de 1 seg
      output_b(0x00);   //Salida de 0x01 por puerto B
      delay_ms(1000);   //Retardo de 1 seg
   } //while
}//main

