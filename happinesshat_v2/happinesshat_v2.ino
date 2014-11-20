#include <Servo.h>

int smilePin = A0;
int buttonPin = 12;
int ledPin = 13;
int stabPin = 10;
Servo stabber;

int state = 0;
// 0 - ready to calibrate (press and it flashes three)
// 1 - reading neutral (press and it flashes two)
// 2 - reading smile (press and it flashes one, READY!)
int lastButtonState = LOW;

int neutralAmt = 0;
int smileAmt = 0;
int smile = 0;

void setup(){
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
  pinMode(smilePin, INPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(stabPin, OUTPUT);
  stabber.attach(stabPin);

}

void loop(){
  smile = analogRead(smilePin);
  handleButton();
  handleSmile();
}

void handleButton() {
  int buttonState = digitalRead(buttonPin);
  //Serial.println(buttonState);
  if (buttonState != lastButtonState) {
    if (buttonState == HIGH) {
      state = (state+1)%3;
      if (state == 0) {
        flashX(1);
        stabber.write(0);
      } else if (state == 1) {
        neutralAmt = smile;
        Serial.print("neutral set to ");
        Serial.println(neutralAmt);
        flashX(2);
      } else if (state == 2) {
        smileAmt = smile;
        Serial.print("smile set to ");
        Serial.println(smileAmt);
        flashX(3);  
      }
    }
    lastButtonState = buttonState;
  }
}

void flashX(int n) {
  for (int i=0; i<n; i++) {
    delay(250);
    digitalWrite(ledPin, HIGH);
    delay(250);
    digitalWrite(ledPin, LOW);
  } 
}

void handleSmile() {
  if (state == 2) {
    int smileVal = map(smile, neutralAmt, smileAmt, 0, 180);
    smileVal = constrain(smileVal, 0, 180);
    Serial.print("smile:");
    Serial.print(smile);
    Serial.print(" smileVal:");
    Serial.println(smileVal);
    stabber.write(smileVal);
    delay(100);
  }
}


