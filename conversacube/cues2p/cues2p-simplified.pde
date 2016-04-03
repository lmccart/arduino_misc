#include <SoftwareSerial.h>

static String cues[60] = {    
  "0confront", "1admit", "0compliment", "0roll eyes", "0empathize", "0look away", 
  "0reveal", "1chime in", "0digress", "1confide", "0forget", "0wink", "0insult", "1relate to", "0confess", 
  "1joke", "0brag", "1care", "0challenge", "0maintain eye contact", "0reminisce", "1interrupt", "0praise", 
  "0raise eyebrows", "0suggest", "1laugh", "0give advice", "1contradict", "0aggravate", "0nod", "0compare", 
  "1criticize", "0commiserate", "1frown", "0wish", "1accuse", "0make fun", "1agree", "0offer", "1consider",
  "0dismiss", "0smile", "0change topic", "1listen", "0lie", "1disagree", "0complain", "0touch", "0plan",
  "1challenge", "0argue", "exaggerate", "0predict", "0shake head", "0question", "1defend", "0share", "1debate",
  "0change subject", "1notice"
};

int time = 0;
int cur_cue = -1;
int cur_set = 0;
boolean flip;

char cue0_chars[34];
char cue1_chars[34];

SoftwareSerial mySerial = SoftwareSerial(0, 1);
SoftwareSerial mySerial1 = SoftwareSerial(3, 2);

void setup() {

  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(8, OUTPUT);

  mySerial.begin(9600);
  mySerial1.begin(9600);
  digitalWrite(8, HIGH);
}

void loop() {
  if (time >= 2000 * 2 + 10) { // change this number for reset time needed // cue time
    cur_set = random(30); //max cues
    flip = random(2);
    time = 0;
    cur_cue = -1;
  }

  if (time >= (cur_cue+1) * 2000) { //cue time
    cur_cue++;
    handleCueOut();
  }
  time++;
  delay(10);
}


void handleCueOut() {
  if (cur_cue >= 2) {  
    mySerial.print(0xFE, BYTE);
    mySerial.print(0x01, BYTE);  
    mySerial1.print(0xFE, BYTE);
    mySerial1.print(0x01, BYTE);
  } 
  else {
    
  //mySerial.print(cur_set);
  //mySerial.print("/");
  //mySerial.println(get_free_memory());
    if (cues[2*cur_set].charAt(0)-48 == cur_cue) {
      remixCue(cues[2*cur_set]).toCharArray(cue0_chars, sizeof(cue0_chars));
      if (flip == 1) mySerial1.print(cue0_chars);
      else mySerial.print(cue0_chars);
    }
    if (cues[2*cur_set+1].charAt(0)-48 == cur_cue) {
      remixCue(cues[2*cur_set+1]).toCharArray(cue1_chars, sizeof(cue1_chars)); 
      if (flip == 1) mySerial.print(cue1_chars);
      else mySerial1.print(cue1_chars);  
    }

  }
}

String werd = String(34);
String remix = String(34);
boolean db;

String remixCue(String c) {
  db = false;
  werd = "";
  remix = "";
  if (c.indexOf(" ") != -1 && c.length() > 16) 
    db = true;

  if (db)
    werd = c.substring(1, c.indexOf(" "));
  else
    werd = c.substring(1, c.length());

  int e;
  if (werd.length() % 2 == 1)
    e = 1+(15 - werd.length())/2;
  else
    e = (16 - werd.length())/2;

  for (int i=0; i<e; i++)
    remix.concat(" "); 
  remix.concat(werd);

  if (db) {
    for (int i=0; i<(16-werd.length()-e); i++)
      remix.concat(" "); 
    werd = c.substring(c.indexOf(" ")+1, c.length());
    if (werd.length() % 2 == 1)
      e = 1+(15 - werd.length())/2;
    else
      e = (16 - werd.length())/2;  

    for (int i=0; i<e; i++)
      remix.concat(" "); 
    remix.concat(werd);   
  }
  return remix.toUpperCase();
}
//extern void *__bss_end;
//extern void *__brkval;
//
//int get_free_memory()
//{
//  int free_memory;
//
//  if((int)__brkval == 0)
//    free_memory = ((int)&free_memory) - ((int)&__bss_end);
//  else
//    free_memory = ((int)&free_memory) - ((int)__brkval);
//
//  return free_memory;
//}





