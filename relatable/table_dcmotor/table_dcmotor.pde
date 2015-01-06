int switchPin = 4; 
int lightPin = 9;

int val = 0;
boolean flash = false;


void setup() {
  Serial.begin(9600); 
  pinMode(switchPin, INPUT);
  pinMode(lightPin, OUTPUT);
}



void loop() {
  
  val = analogRead(switchPin)/4;
  
  Serial.println(val); // read the pot value

  if (val >= 30){
    analogWrite(lightPin, val);  
    delay(20); 
  } else {
    if (flash){
      analogWrite(lightPin, 255);
      flash = false;
    } else {
      analogWrite(lightPin, 0); 
      flash = true;
    }
    
    delay(200);

  }                     // wait 10 milliseconds before the next loop
}



