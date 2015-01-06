#include "WProgram.h"
void setup();
void loop();
int analogInput = 5;      // the analog pin that the sensor is on
int analogOutput = 13;    // the value returned from the analog sensor
int analogValue;

void setup() {   

  pinMode(analogInput, INPUT);    // initialize the button pin as a input:
  pinMode(analogOutput, OUTPUT);
  Serial.begin(9600);
} 

void loop() 
{ 
  // read sensor

  Serial.println(analogRead(analogInput));
  delay(30);     


}






int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

