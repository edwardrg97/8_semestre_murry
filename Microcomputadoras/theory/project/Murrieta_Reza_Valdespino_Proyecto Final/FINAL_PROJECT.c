//Proyecto Final
#include <16F877A.h>
#fuses HS,NOWDT,NOPROTECT
#device ADC=10
#use delay(clock=20000000)
//Manejo I2C
#use i2c(MASTER,SDA=PIN_C4,SCL=PIN_C3,SLOW,NOFORCE_SW)
//Comunicaci�n serial asincrona
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
//Manejo del LCD por I2C
#include <i2c_LCD.c>

#org 0x1F00, 0x1FFF void loader16F877(void) {}


char option='P';
int tempo=1;
int contador=0;
long seg=0;
long duty=0;
int vel=0;

//Interrupci�n de desbordamiento de TIMER 1 para contar 2 minutos
#int_TIMER1
void TIMER1_isr(){
   if(seg==114){     
   //Al obtener 2 mins (120 seg) el ciclo del programa terminar�
      tempo=0;   //Fin del ciclo
      lcd_gotoxy(1,1);
      
      //Mensaje en display cuando se cumplan los 2 minutos
      printf(lcd_putc,"2 MINUTOS\n");
      lcd_gotoxy(1,2);
      printf(lcd_putc,"TRANSCURRIDOS\n");
      output_b(0x00);
   }else{
      
      
      if(contador==9){//Contador para obtener 1 segundo
         contador=0;
         seg++;
         //printf("%ld\n",seg);
      }else{
         contador++;  
      }
   }
}

//Funci�n para obtener el PWM para variar la velocidad.
void cambio_vel(){
   set_adc_channel(0);  //Selecci�n canal 0
   duty=read_adc();     //Converisi�n A/D
   set_pwm1_duty(duty); //Asignar ciclo duty a PWM1
}
void main(){
   //TIMER 1
   
   set_timer1(0);
   setup_timer_1(T1_INTERNAL|T1_DIV_BY_8);
   enable_interrupts(INT_TIMER1);
   enable_interrupts(GLOBAL);
   
   //Configuraci�n para PWM
   setup_adc(ADC_CLOCK_INTERNAL);//Configuraci�n Convetidor A/D
   setup_port_a(ALL_ANALOG);//Puerto A como convertidores
   
   setup_ccp1(CCP_PWM);//Uso de CCP1 para el manejo de PWM
   setup_timer_2(T2_DIV_BY_4,255,1);//Manejo de timer 2 para realizar la comparaci�n
   delay_ms(100);
   
   //Configuraci�n I2C con LCD
   i2c_start();//Inicializaci�n I2C
   lcd_init(0x44,16,2);//Manejo de LCD por I2C (Direcci�n 0x44)
                        //Manejo de PCF8574, A2=0, A1=1 A0=0, Escritura=0
                        //Diplay de 16 x 2
   lcd_clear();         
   lcd_gotoxy(1,1);     //Impresi�n en (1,1)
   
   printf(lcd_putc,"A CORRER\n\r");
   delay_ms(250);
   
   set_tris_b(0x00);
   output_b(0x00);
   
   
   
   while(tempo==1){
      option=getchar();
      if(tempo==1){
      switch(option){
         case 'A':   //Opci�n de avanzar
            lcd_clear();
            lcd_gotoxy(1,1);
            printf(lcd_putc,"AVANZANDO");
            //00 101 101
            vel=0x2D;
            
         break;
         case 'T':   //Opci�n de retroceder
            lcd_clear();
            lcd_gotoxy(1,1);
            printf(lcd_putc,"RETROCEDIENDO");
            //00 110 110
            vel=0x36;
         break;
         case 'D':   //Opci�n de giro a la derecha
            lcd_clear();
            lcd_gotoxy(1,1);
            printf(lcd_putc,"GIRO A LA\n");
            lcd_gotoxy(1,2);
            printf(lcd_putc,"DERECHA\n");
            //00 000 101
            vel=0x05;
         break;
         case 'I':   //Opci�n de giro a la izquierda
            lcd_clear();
            lcd_gotoxy(1,1);
            printf(lcd_putc,"GIRO A LA\n");
            lcd_gotoxy(1,2);
            printf(lcd_putc,"IZQUIERDA\n");
            //00 101 000
            vel=0x28;
         break;
         default:    //Opci�n de parar
            lcd_clear();
            lcd_gotoxy(1,1);
            printf(lcd_putc,"DETENIDO");
            //00 000 000
            vel=0x00;
         break;
         
      }
      cambio_vel();  //Realiza la lectura del convertidor y cambia el duty (PWM)
      output_b(vel); //Asigna la direcci�n a la salida B.
      }
   }

}

