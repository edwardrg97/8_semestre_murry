#include<16f877.h>

#fuses HS, NOWDT, NOPROTECT, NOLVP
#use delay(clock=20000000)

#Global variables
int count = 0;
int time= 0;

#int_rtcc
clock_isr() {
   if(time == 19) {
      output_b(count);
      count++;
      time = 0;
   }
   time++;
}

void main() {
   set_timer2(0);
   setup_counters(RTCC_INTERNAL, RTCC_DIV_256); 
   enable_interrupts(INT_RTCC);
   enable_interrupts(GLOBAL); 
   while(1) {
   }
}