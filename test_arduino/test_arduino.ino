void setup() {
  Serial.begin(57600);
}

void loop() {
  delay(5000);
  sendMessage(0);
  delay(5000);
  sendMessage(4);
  delay(5000);
  sendMessage(1);
  delay(5000);
  sendMessage(5); 
}

void sendMessage(int msg) {
  Serial.write(0xFE);
  Serial.write(msg);
  Serial.write(0xFF);
}
