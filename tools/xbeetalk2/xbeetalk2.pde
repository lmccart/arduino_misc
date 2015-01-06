#include <NewSoftSerial.h>

NewSoftSerial mySerial =  NewSoftSerial(1, 2);

int count = 0;


void setup()  {
  pinMode(13, OUTPUT);
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
  
  if(count%1000 == 0){
     mySerial.print('9'); 
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
