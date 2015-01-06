
int audPin0 = 11;
int audPin1 = 10;
int audPin2 = 9;
int audPin3 = 8;

int distPin0 = 7;
int distPin1 = 6;
int distPin2 = 5;
int distPin3 = 4;

int aud0, aud1, aud2, aud3, dist0, dist1, dist2, dist3;

void setup(){
  pinMode(1, OUTPUT);
  pinMode(18, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(14, OUTPUT);
  
  pinMode (audPin0, INPUT);
  pinMode (audPin1, INPUT);
  pinMode (audPin2, INPUT);
  pinMode (audPin3, INPUT);
  
  pinMode (distPin0, INPUT);
  pinMode (distPin1, INPUT);
  pinMode (distPin2, INPUT);
  pinMode (distPin3, INPUT);
  
  Serial.begin(115200);
  //Serial.begin(9600);
  Serial1.begin(115200);
  Serial2.begin(115200);
  Serial3.begin(115200); 
  
  Serial.print(0x7C, BYTE);
  Serial.print(0x04, BYTE);
  
 // Serial.print("0x7C 0x04");
}

void loop(){
  //Serial.print(0x08, BYTE);
  //Serial.print(0x7C, BYTE);
  //Serial.print("012345");
  //Serial1.print("1");
  //Serial2.print("2");
  //Serial3.print("3");
  
  aud0 = analogRead (audPin0);
  aud1 = analogRead (audPin1);
  aud2 = analogRead (audPin2);
  aud3 = analogRead (audPin3);
  
  dist2 = analogRead (distPin2);
  
//  Serial.print ("aud0 = ");
//  Serial.print(aud0);
//  Serial.print (" aud1 = ");
//  Serial.print(aud1);
//  Serial.print (" aud2 = ");
//  Serial.print(aud2);
//  Serial.print (" aud3 = ");
//  Serial.print(aud3);
//  Serial.print (" dist2 = ");
//  Serial.println(dist2);
  delay (1000);
 
}

