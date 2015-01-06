int switchPin = 0; 
int lightPin = 9;
int dir = 2;

int val = 250;
boolean flash = false;


void setup() {
  Serial.begin(9600); 
  pinMode(switchPin, INPUT);
  pinMode(lightPin, OUTPUT);
}



void loop() {

  if ((val <= 0) || (val >= 254)) { 
    dir *= -1;
  }

  val += dir;
  
 // val = analogRead(switchPin)/4;

  Serial.println(val); // read the pot value

  analogWrite(lightPin, val);
  delay(30);

}




