#include "WProgram.h"
void setup();
void loop();
int sensorPin = 1;

void setup() {
   Serial.begin(9600);
   pinMode(sensorPin, INPUT);
}

void loop(){
  int val = analogRead(sensorPin);
  Serial.println(val); 
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

