#define txLed 5
#define rxLed 4
#define analogLed 13

#include "WProgram.h"
void setup();
void setDestination();
void blink(int howManyTimes);
void loop();
void handleSerial();
int inByte = -1;
char inString[6];
int stringPos = 0;
int count = 0;

void setup(){
   // configure serial communications
   Serial.begin(9600);
  
   // configure output pins
   pinMode(txLed, OUTPUT);
   pinMode(rxLed, OUTPUT);
   pinMode(analogLed, OUTPUT); 
   
   delay(1000);
   
   // set XBee's destination addr
   setDestination();
   // blink the TX LED indicating main program about to start
    blink(3);
}

void setDestination(){
   // put radio in command mode
   Serial.print("+++");
   
     
//   // wait for radio to respond with OK\r
   char thisByte = 0;
   while (thisByte != '\r'){
      if (Serial.available() > 0){
          thisByte = Serial.read(); 
      }
   } 
    
   // set dest addr with 16-bit addressing
   Serial.print("ATDH0, ATDL1234\r");
   Serial.print("ATMY1234\r");
   
   //set PAN ID
   Serial.print("ATID111\r");
   Serial.print("ATCN\r"); // go into data mode
}

void blink(int howManyTimes){
   for (int i=0; i < howManyTimes; i++){
      digitalWrite(txLed, HIGH);
      delay(200);
      digitalWrite(txLed, LOW);
      delay(200);
   }
}

void loop(){
 
   // update count
   count++;
   
   // listen for incoming serial data
   if (Serial.available() > 0){
      //turn on RX LED whenever reading data
      digitalWrite(rxLed, HIGH);
      handleSerial();
   } 
   else {
      // turn off receive LED when no incoming data
     digitalWrite(rxLed, LOW); 
   }
   
   // every 2000 count, send message
   if (count%13000 == 0){
      // light TX LED when sending
      digitalWrite(txLed, HIGH);
      Serial.print("6");
      Serial.print("\r");
      
      // turn off TX LED
      digitalWrite(txLed, LOW);
   }
   
   
}

void handleSerial(){
   inByte = Serial.read();
   
   // save only ASCII numeric characters (ACSCII 0 - 9)
   if ((inByte >= '0') && (inByte <= '9')){
     inString[stringPos] = inByte;
     stringPos++; 
   }
   
   // if you get an ASCII carriage return
   if (inByte == '\r'){
      // convert string to number
      int brightness = atoi(inString);
   }
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

