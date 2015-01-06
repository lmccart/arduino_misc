
#include <Servo.h>      // include the servo library
Servo servoMotor;       // creates an instance of the servo object to control a servo


int analogPin = 1;      // the analog pin that the sensor is on
int analogValue = 0;    // the value returned from the analog sensor
int maxAnalogValue = 600;

int servoPin = 5;       // Control pin for servo motor, may only be pin 9 or 10
int ledPin = 2;

int buttonPin = 6;      // the digital pin that the button is on
int buttonState = 0;    // current state of button
int lastButtonState = 0; // last state of button
int state = 0;          // 0 - neutral, 1 - measure min smile, 2 - measure max smile, 3 - ready/providing feedback
int lastState = 0;
int minSmile = 0;       // value of min smile
int maxSmile = 0;       // value of max smile

int painValue = 0;      // value of mapped sensor that determines rot of servo
int lastPainValue = 0;

int count = 0;
int maxCount = 5000;

float average = 0;
float smile = 0;



void setup() {   

  pinMode(buttonPin, INPUT);    // initialize the button pin as a input:
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  servoMotor.attach(servoPin);  // attaches the servo on pin 2 to the servo object
} 

void loop() 
{ 
  // read sensor
  analogValue = maxAnalogValue - analogRead(analogPin);             // read the analog input (value between 0 and 1023)


  // read button, update state
  lastButtonState = buttonState;
  buttonState = digitalRead(buttonPin);
  if (buttonState != lastButtonState){
    if (buttonState == HIGH){
      state += 1;
      if (state > 3) state = 0;
      Serial.println(state);
    }
  //  else Serial.println(state);
  }

  // update based on state
  if (state != lastState){
    lastState = state;
    switch(state){
    case 0:
      // turn off LED
      digitalWrite(ledPin, LOW);

      Serial.println("ready for calibration");
      break;
    case 1: // min smile measured
      minSmile = analogValue;

      //flash LED x1
      digitalWrite(ledPin, HIGH);
      delay(500);
      digitalWrite(ledPin, LOW);

      Serial.print("minSmile = ");
      Serial.println(minSmile);

      break;
    case 2: 
      maxSmile = analogValue;
      // flash LED x2
      digitalWrite(ledPin, HIGH);
      delay(500);
      digitalWrite(ledPin, LOW);
      delay(500);
      digitalWrite(ledPin, HIGH);
      delay(500);
      digitalWrite(ledPin, LOW);

      Serial.print("maxSmile = ");
      Serial.println(maxSmile);
      break;

    case 3:
      // turn on LED
      digitalWrite(ledPin, HIGH);

      Serial.println("calibrated");
      break;
    }
  }

  // if in feedback state, rotate servo based on mapped sensor input
  if (state == 3){ 
    // determine smile value
    if (map(analogValue, minSmile, maxSmile, 0, 100) < 50) smile = 0;
    else smile = 1.0;
    Serial.print("smile = ");
    Serial.print(smile);
    
    // update average
    average = ((average*(float)count) + smile)/((float)count + 1.0);
    Serial.print(" average = ");
    Serial.print(average);
    if (count < maxCount) count++;
    
    Serial.print(" count = ");   
    Serial.print(count);
    
    if ((smile == 1.0) || (average > 0.5)) painValue = 90;
    else painValue = 0;
    
    if (painValue != lastPainValue) servoMotor.write(painValue);
    Serial.print(" pain = ");
    Serial.println(painValue);
    lastPainValue = painValue;
    delay(30);
    
  }
}



