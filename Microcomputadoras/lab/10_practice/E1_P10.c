#include<16F877.h>
#fuses HS,NOWDT,NOPROTECT
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)

#int_EXT
ext_int(){                    //Interrupci�n del Flanco por RB0
   output_toggle(PIN_D0);     //Cambio del estado de PIN D0 cada vez que se
                              //de la interrupci�n
}

void main(){
   ext_int_edge(L_TO_H);         //Detecci�n de pin de subida
   enable_interrupts(INT_EXT);   //Activa la interrupci�n del flanco por RB0
   enable_interrupts(GLOBAL);    //Activaci�n deneral de interrupciones
   output_low(PIN_D0);           //PIN D0 abajo
   
   while(TRUE){
   }
}
