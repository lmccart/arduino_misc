#include <NewSoftSerial.h>
NewSoftSerial mySerial =  NewSoftSerial(1, 2); //instead of 1,2 (rx,tx)

void setup()
{

  Serial.begin(9600);
  mySerial.begin(9600);

}

void loop()
{
  serialHandler();
  char val = (char)mySerial.read();
  if(val == '8') //red button  
  {  
    Serial.print("8");
    //Serial.print(reading);
  }
} 



void serialHandler()
{
  if (mySerial.available()) {
    Serial.print((char)mySerial.read());
  }
  if (Serial.available()) {
    mySerial.print((char)Serial.read());
  }

  delay(100);

}

