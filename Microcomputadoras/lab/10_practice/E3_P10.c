#include<16F877.h>
#fuses HS,NOWDT,NOPROTECT
//Directivas CONVERTIDOR
#device ADC=8     //Bits de convertidor A/D
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)  //Configuración serie
#define use_portb_lcd true       //Puerto B para LCD
#include <lcd.c>
#org 0x1F00, 0x1FFF void loader16F877(void) {}

long convert;              //Conversión A/D
float res;                 //Resultado de Volts
long cont=0;

float volts(long conv);          //Función de conversión a volts

#int_rtcc
//Interrupción de desbordamiento de TIMER0
void clock_isr(){
   
   if(cont==763){       //Impresiones cada 10 seg
      convert=read_adc();        // Obtener el resultado de la conversion
      res=volts(convert);        //Conversión a volts   
      
      //Impresión por transmisión a puerto Serie
      printf("DECIMAL=  %04ld\n\r",convert);
      printf("HEXDECIMAL=  %04lx\n\r\n\r",convert);  
      
      //Impresión a Display LCD
      lcd_gotoxy(1,1);
      printf(lcd_putc,"%1.2f V\n",res);
      
      //Salida por el puerto B
      output_d(convert);
      cont=0;
   }else{
      cont++;        //Contador para realizar impresión
   }
}

float volts(long con){
   res=(float)con*(0.01953);     //Conversión por la resolución
   return res;
}

void main(){
   lcd_init();                //Inicia le Display LCD
   setup_port_a(ALL_ANALOG);  //Define al puerto A como analógico
   setup_adc(ADC_CLOCK_INTERNAL); // Define frecuencia de muestreo del 
                                    //convertidor A/D
   set_adc_channel(0);          // Configura el canal a usar
   delay_us(20); // retardos
   
   set_timer0(0);                //Timer0 en 0X00
   setup_counters(RTCC_INTERNAL,RTCC_DIV_256);//Frecuencia y prescalado
   enable_interrupts(INT_RTCC); //Activación interrupción desbordamiento TIMER0
   enable_interrupts(GLOBAL);    //Activación interrupciones globales
   
   
   set_tris_d(0x00);             //Salidas por puerto D
   output_d(0x00);               //Salida 0x00 de puerto d
   while(TRUE){
   }

}
