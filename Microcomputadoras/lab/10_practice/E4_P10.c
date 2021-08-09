#include <16f877a.h>   // Librería del microcontrolador
#device adc=8
#fuses HS,NOWDT,NOPROTECT //activa alta velocidad y no protege el código
#use delay(clock=20000000) //f=20Mhz
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#define use_portb_lcd true
#include <lcd.c>
#org 0x1F00, 0x1FFF void loader16F877(void) {}

int  cont_hex=0;     //Contador de 8 bits
int  convert=0;      //Conversión de A/D
long cont_v=0;       //Contador para impresión de voltajes
long cont_n=0;       //Contador para impresión de info en serie
float res=0;         //Conversión a Volts

#int_rtcc
void clock_isr(){
//código de la rutina
//printf("%ld\n\r",cont_v);
   cont_v++;
   cont_n++;
   if(cont_v==40){         //10 segundos conversión e impresión de Volts en LCD
      delay_us(20); // retardos
      convert=read_adc();     //CONVERTIDOR A/D
      res=(float)convert*(0.01953); //Conversión a volts, 0.1953 resolución
      lcd_gotoxy(1,1);
      printf(lcd_putc,"%1.2f V",res);     //Impresión
      cont_v=0;
   }
   
   if(cont_n==100){                 //Impresión cada 25 seg
      printf("Alumno:Murrieta Villegas, Alfonso\n\r");
      printf("\t-->No. de Cuenta: 315048937\n\r");
      printf("\n\r");
      printf("Alumno:Reza Chavarria Sergio Gabriel\n\r");
      printf("\t-->No. de Cuenta: 315319077\n\r");
      printf("\n\r");
      printf("Alumno:Valdespino Mendieta, Joaquin\n\r");
      printf("-->No. de Cuenta: 315115501\n\r");
      printf("\n\r");
      printf("Grupo de teoria: 01\n\r");
      printf("Grupo de laboratorio: 04\n\r");
      printf("\n\r\n\r");
      cont_n=0;
   }
}

void main(){
   lcd_init();
   setup_port_a(ALL_ANALOG);  //Define al puerto A como analógico
   // Define frecuencia de muestreo del convertidor A/D
   setup_adc(ADC_CLOCK_INTERNAL); 
   set_adc_channel(0);          // Configura el canal a usar
   delay_us(20); // retardos
   
   set_timer0(0); // Inicia TIMER0 en 00H
   setup_counters(RTCC_INTERNAL,RTCC_DIV_256); //Fuente de reloj y pre-divisor
   enable_interrupts(INT_RTCC); //Habilita interrupción por TIMER0
   enable_interrupts(GLOBAL); //Habilita interrupciones generales
   
   set_tris_d(0x00);
    while(true){
      
      output_d(cont_hex);     //Salida de contador por puerto D
      if(cont_hex==0xff){     //Si llega a 0xff reinicia conteo
         cont_hex=0;
      }else{                  //Aumenta el contador
         cont_hex++;
      }
      delay_ms(250);
      
      
    }
}
