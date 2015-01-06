/*Capacitative Sensing Code for ATMega328 Arduinos*/

#include "WProgram.h"
void setup();
void loop ();
char getcap(char pin);
void setup() {

  Serial.begin(9600);      // connect to the serial port

}

void loop () {

  char capval[6];
  char pinval[6] = {1<<PINB0,1<<PINB1,1<<PINB2,1<<PINB3,1<<PINB4,1<<PINB5};
  delay(1000);
  for(char i = 0; i < 6; i++)
  {
    capval[i] = getcap(pinval[i]);
    Serial.print("digital ");
    Serial.print(i+8, DEC);
    Serial.print(": ");
    Serial.println(capval[i], DEC);
  }
  Serial.println("");

}

// returns capacity on one input pin // pin must be the bitmask for the pin e.g. (1<<PB0) 
char getcap(char pin) {

  char i = 0;
  DDRB &= ~pin;          // input
  PORTB |= pin;          // pullup on
  for(i = 0; i < 8; i++)
    if( (PINB & pin) ) break;
  PORTB &= ~pin;         // low level
  DDRB |= pin;           // discharge
  return i;

} 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

