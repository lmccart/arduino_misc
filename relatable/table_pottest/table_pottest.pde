int pot0Pin = 0;   
boolean pot0InUse = false;
int pot0Last;
int pot0Value;

int pot1Pin = 1;
boolean pot1InUse = false;
int pot1Last;
int pot1Value;

int pot2Pin = 2;
boolean pot2InUse = false;
int pot2Last;
int pot2Value;

int pot3Pin = 4;
boolean pot3InUse = false;
int pot3Last;
int pot3Value;

int potSumValue = 0;
int potAvgValue = 0;
int potMinThresh = 3;

int potCount = 0;

int lightPin = 9;    

int buttonPin = 4;

boolean flash = false;

void setup() {
  Serial.begin(9600); 
  pinMode(lightPin, OUTPUT);
  pinMode(buttonPin, INPUT);

  reset();

  pot0Value = constrain(map(analogRead(pot0Pin)/4, 70, 180, 0, 255), 0, 255);
  pot0Last = pot0Value;
  Serial.print("POT0START = ");
  Serial.print(pot0Value);
  pot1Value = constrain(map(analogRead(pot1Pin)/4, 70, 180, 0, 255), 0, 255);
  pot1Last = pot1Value;
  Serial.print(" POT1START = ");
  Serial.print(pot1Value);
  pot2Value = constrain(map(analogRead(pot2Pin)/4, 70, 180, 0, 255), 0, 255);
  pot2Last = pot2Value;
  Serial.print(" POT2START = ");
  Serial.print(pot2Value);
  pot3Value = constrain(map(analogRead(pot3Pin)/4, 70, 180, 0, 255), 0, 255);
  pot3Last = pot3Value;
  Serial.print(" POT3START = ");
  Serial.println(pot3Value);
}

void loop() {

  if (digitalRead(buttonPin) == 0) {
    reset();
  } 
  else {
    checkUse();
    readPots();

    doLight(); 

  }
  delay(100);               
}

void checkUse(){
  if (!pot0InUse) {
    if (abs(pot0Last - pot0Value) > potMinThresh){
      pot0InUse = true;
      potCount++;
      Serial.println("pot0InUse");
    }
  }
  if (!pot1InUse) {
    if (abs(pot1Last - pot1Value) > potMinThresh){
      pot1InUse = true;
      potCount++;
      Serial.println("pot1InUse");
    }
  }
  if (!pot2InUse) {
    if (abs(pot2Last - pot2Value) > potMinThresh){
      pot2InUse = true;
      potCount++;
      Serial.println("pot2InUse");
    }
  }
  if (!pot3InUse) {
    if (abs(pot3Last - pot3Value) > potMinThresh){
      pot3InUse = true;
      potCount++;
      Serial.println("pot3InUse");
    }
  }
}


void readPots(){

  potSumValue = 0;


  pot0Last = pot0Value;
  pot0Value = constrain(map(analogRead(pot0Pin)/4, 70, 180, 0, 255), 0, 255);
  pot1Last = pot1Value;
  pot1Value = constrain(map(analogRead(pot1Pin)/4, 70, 180, 0, 255), 0, 255);
  pot2Last = pot2Value;
  pot2Value = constrain(map(analogRead(pot2Pin)/4, 70, 180, 0, 255), 0, 255);
  pot3Last = pot3Value;
  pot3Value = constrain(map(analogRead(pot3Pin)/4, 70, 180, 0, 255), 0, 255);

  if(pot0InUse){
    potSumValue += pot0Value;
    Serial.print("POT0 = ");
    Serial.print(pot0Value);
  }
  if(pot1InUse){
    potSumValue += pot1Value;
    Serial.print(" POT1 = ");
    Serial.print(pot1Value);
  }
  if(pot2InUse){
    potSumValue += pot2Value;
    Serial.print(" POT2 = ");
    Serial.print(pot2Value);
  }
  if(pot3InUse){
    potSumValue += pot3Value;
    Serial.print(" POT3 = ");
    Serial.print(pot3Value);
  }
  
  if(potCount > 0){

    potAvgValue = potSumValue/potCount;
    Serial.print(" AVG = ");
    Serial.println(potAvgValue);
  }
}



void doLight(){
  if (potCount > 0){

    if (potAvgValue >= 30){
      analogWrite(lightPin, potAvgValue);  
      delay(20); 
    } 
    else {
      if (flash){
        analogWrite(lightPin, 255);
        flash = false;
      } 
      else {
        analogWrite(lightPin, 0); 
        flash = true;
      }

      delay(200);

    }   
  }
}

void reset() {
  
  analogWrite(lightPin, 0);
  
  pot0InUse = false;
  pot1InUse = false;
  pot2InUse = false;
  pot3InUse = false; 

  potAvgValue = 0;
  potSumValue = 0;
  potCount = 0;
  flash = false;
  Serial.println("RESET");
}


