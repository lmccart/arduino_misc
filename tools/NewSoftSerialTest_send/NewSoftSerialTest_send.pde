// send code: this one flashes LED on send


#include <NewSoftSerial.h>
#define ledPin 13

NewSoftSerial mySerial(0, 1);

float startTime = 0;
float pauseTime = 1000;

void setup()  
{
  Serial.begin(9600);
  mySerial.begin(9600);
}

void loop()                     // run over and over again
{
  
  handleSerial();
  
  if (millis() - startTime > pauseTime){
    startTime = millis();
    Serial.print("5");
    digitalWrite(ledPin, HIGH);
    delay(20);
    digitalWrite(ledPin, LOW);
  }
  

}

void handleSerial(){
  if (mySerial.available()) {
      char val = (char)mySerial.read();
      Serial.print(val);
  }
  if (Serial.available()) {
      char val = (char)Serial.read();
      mySerial.print(val);
  }
  delay(100);  
}
