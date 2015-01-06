
#include <NewSoftSerial.h>

#include "WProgram.h"
void setup();
void loop();
NewSoftSerial mySerial(2, 3);

void setup()  
{
  Serial.begin(9600);
  Serial.println("Goodnight moon!");

  // set the data rate for the NewSoftSerial port
  mySerial.begin(9600);
  mySerial.println("Hello, world?");
}

void loop()                     // run over and over again
{

  if (mySerial.available()) {
      Serial.print((char)mySerial.read());
  }
  if (Serial.available()) {
      mySerial.print((char)Serial.read());
  }
  delay(100);
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

