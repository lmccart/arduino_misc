#include <NewSoftSerial.h>

#include "WProgram.h"
void setup();
void loop();
void handleSerial();
NewSoftSerial mySerial =  NewSoftSerial(1, 2);

int count = 0;


void setup()  {
  Serial.begin(9600);
  Serial.println("Goodnight moon!");
  // set the data rate for the SoftwareSerial port
  mySerial.begin(9600);
  mySerial.println("Hello, world?");
}



void loop()                     // run over and over again
{
  handleSerial();
  
  count++;
  
  if(count%3000 == 0){
     mySerial.print('8'); 
  }

}

void handleSerial(){
  
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

