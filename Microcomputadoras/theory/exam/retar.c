#include<16f877.h>
#fuses HS, NOPROTECT,
#use delay(clock=20000000)                      
#org 0x1F00, 0x1FFF void loader16F877 (void) {} 

int main() {
   int count = 0;
   while (true) {
      output_b(count);
      delay_ms(400);
      count++;
   }
   return 0;
}