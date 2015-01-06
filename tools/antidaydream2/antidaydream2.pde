const int pwPin = 12; // digital pin 7 for reading pulse width from MaxSonar device
const int vibePin = 2; // digital pin 11 for sending vibration signal to motor

long cm, pulse;
const int maxDistance = 80; // maximum distance for testing presence of person

boolean inConversation;
boolean vibrating;

// all timing in seconds!
const float vibeTime = 1.0;
float nonVibeTime;
float seconds;
float timerStart;

void setup() {
  Serial.begin(9600);
  pinMode(pwPin, INPUT);
  pinMode(vibePin, OUTPUT);
  
  vibrating = false;
  inConversation = false;
}

void loop() { 
    getPulse();

    if((pulse <= maxDistance) && (!inConversation)){
      startVibration(); 
    } else if ((pulse > maxDistance) && (inConversation)){
      stopVibration();
    }
    
    if (inConversation) {
      handleVibration();
    }
}

void startVibration(){
  Serial.println("start vibration");
  inConversation = true;
  vibrating = true;
  timerStart = seconds;
}

void stopVibration(){
  Serial.println("stop vibration");
  digitalWrite(vibePin, LOW); 
  inConversation = false;
  vibrating = false;
  timerStart = seconds;
}

void handleVibration(){
  if(vibrating){
    if(seconds - timerStart > vibeTime){
      vibrating = false;
      timerStart = seconds;
      Serial.println("low");
      digitalWrite(vibePin, LOW); 
      nonVibeTime = random(10.0,15.0);
      Serial.println(nonVibeTime);
    }
  } else if (seconds - timerStart > nonVibeTime) {
      vibrating = true;
      timerStart = seconds;
      Serial.println("high");
      digitalWrite(vibePin, HIGH);
  }
  seconds = millis()/1000;
}


void getPulse(){
    
   // MAXSONAR HANDLE
  pinMode(pwPin, INPUT);

  pulse = 2.54*pulseIn(pwPin, HIGH)/147;
   
}


