#include <16f877a.h>   // Librería del microcontrolador
#fuses HS,NOPROTECT //activa alta velocidad y no protege el código
#use delay(clock=20000000) //f=20Mhz
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}
long cont_RB0=0;//Contador de INTERRUPCIÓN RB0
long rec_data=0;//Contador de recibimiento de datos por serie
int  cont_hex=0;//Contador de 8 bits

long contador=0;
long aux=0;
int unidad=0;//Unidades de contador decimal en display de 7 segm
int decena=0;//Decenas de contador decimal en display de 7 segm
int asc_dec=0;//Conteo ascendente=0, descentende=1
char info;//Caracter obtenido

#int_rtcc      //Interrupción desbordamiento TIMER0
void clock_isr(){

   aux++;
   if(aux==15){
      output_d(cont_hex);
      cont_hex++;
      aux=0;
   }
   if(cont_hex==0xff){
      cont_hex=0;
   }
}

#int_rb        //Interrupción RB4-RB7
void port_rb(){         
//Revisa que pin fue activado
   if(input(PIN_B4)){
      printf("INTERRUPCIÓN RB4 ACTIVADA\n\r");
   }else if(input(PIN_B5)){
      printf("INTERRUPCIÓN RB5 ACTIVADA\n\r");
   }else if(input(PIN_B6)){
      printf("INTERRUPCIÓN RB6 ACTIVADA\n\r");
   }else if(input(PIN_B7)){
      printf("INTERRUPCIÓN RB7 ACTIVADA\n\r");
   }
}

#int_ext         //Interrupción de flanco de RB0
void detecta_rb0(){
   cont_RB0++;
   
   printf("INTERRUPCIÓN RB0: %ld\n\r",cont_RB0);
}

#int_rda          //Interrupción de recibimiento de datos por puerto serie
void recepcion_serie(){    
//código de la rutina de interrupción
   info=getchar();
   rec_data++;
   printf("\tDATOS RECIBIDOS <%c>. TOTAL=%ld\n\r",info,rec_data);
}

void main(){
   set_timer0(0); // Inicia TIMER0 en 00H
   setup_counters(RTCC_INTERNAL,RTCC_DIV_256); //Fuente de reloj y pre-divisor
   enable_interrupts(INT_RTCC); //Habilita interrupción por TIMER0
   ext_int_edge(L_TO_H);
   enable_interrupts(INT_RB);
   enable_interrupts(INT_EXT);
   enable_interrupts(INT_RDA);
   enable_interrupts(GLOBAL); //Habilita interrupciones generales
   set_tris_a(0x00);
   set_tris_e(0x00);
   set_tris_d(0x00);
    while(true){   
      
      output_a(unidad);
      output_e(decena);
      if(asc_dec==0){   //Conteo Ascendente 
         contador++;
         unidad++;
         if(contador==10){ //Caso 10-19
            unidad=0;
            decena=1;  
         }else if (contador==20){   //Caso 20
            unidad=0;
            decena=2;
            asc_dec=1;              //Activar conteo descendente
         }
         
      }else{        //Conteo descendente 
         contador--;
         unidad--;
         if(contador==19){ //Caso 10-19
            decena=1;
            unidad=9;
         }else if(contador==9){  //Caso 0-9
            unidad=9;
            decena=0;
         }else if(contador==0){  //Caso 0
            unidad=0;
            decena=0;
            asc_dec=0;           //Activar conteo ascendente
         }
         
      }
      delay_ms(1000);
    }
}
