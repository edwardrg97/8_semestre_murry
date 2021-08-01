#include <16f877.h>   //Incluye la librería del microprocesador
#fuses HS,NOPROTECT, 
#use delay(clock=20000000) //Frec. de oscilación 20Mhz
//Configura y activa el puerto SERIAL
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7) 
#org 0x1F00, 0x1FFF void loader16F877(void) {} 
int cont;   //Contador
char opt;   //Caracter de opciones
int val;    //Información de salida
void main(){
   while(1){
      opt=getchar();//Obtener caracter de la terminal
      switch(opt){
         case '0':                  //Apagador de los bits
            printf("0) Todos los bits apagados\n\r");
            output_b(0x00);
         break;
         case '1':                  //Encender los bits
            printf("1) Todos los bits encendidos\n\r");
            output_b(0xFF);
         break;
         case '2':                 //Caso del corrimiento a la derecha
            printf("2) Corrimiento a la derecha\n\r");
            val=0x80;
            for(cont=0x00; cont<0x08; cont++)      //Ciclo del corrimiento
            {
               output_b(val);
               rotate_right(&val,1);
               delay_ms(500);
            }
         break;
         case '3':                  //Caso del corrimiento a la izquerda
            printf("3) Corrimiento a la izquierda\n\r");
            val=0x01;
            for(cont=0x00; cont<0x08; cont++)      //Ciclo para el corrimiento
            {
               output_b(val);
               rotate_left(&val,1);
               delay_ms(500);
            }
         break;
         case '4':                                 //Corrimiento de ambos lados
            printf("4) Derecha a Izquierda\n\r");
            val=0x80;
            for(cont=0x00; cont<0x07; cont++)      //Corr. a la derecha
            {
               output_b(val);
               rotate_right(&val,1);
               delay_ms(500);
            }
            for(cont=0x00; cont<0x08; cont++)      //Corr. a la izqu
            {
               output_b(val);
               rotate_left(&val,1);
               delay_ms(500);
            }
         break;  
         case '5':                                 
            printf("5) Encendido y apagado\n\r");
            output_b(val);
            output_b(0x00);                       //Apagado
            delay_ms(500);
            output_b(0xff);                        //Encendido
            delay_ms(500);
         break;
         default:
            printf("Dato fuera del rango\n\r");    //Si se ingresa un caracter 
            //diferente, muestra el rango
         break;
      }
   }
}

