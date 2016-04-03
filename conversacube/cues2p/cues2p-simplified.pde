#include <SoftwareSerial.h>

static String cues[60] = {
  "confront", "admit", "compliment", "roll eyes", "empathize", "look away",
  "reveal", "chime in", "digress", "confide", "forget", "wink", "insult", "relate to", "confess",
  "joke", "brag", "care", "challenge", "maintain eye contact", "reminisce", "interrupt", "praise",
  "raise eyebrows", "suggest", "laugh", "give advice", "contradict", "aggravate", "nod", "compare",
  "criticize", "commiserate", "frown", "wish", "accuse", "make fun", "agree", "offer", "consider",
  "dismiss", "smile", "change topic", "listen", "lie", "disagree", "complain", "touch", "plan",
  "challenge", "argue", "exaggerate", "predict", "shake head", "question", "defend", "share", "debate",
  "change subject", "notice"
};

int time = 0;
int cur_cue = -1;
int cue_interval = 1000; // 1 per second to test
boolean cur_user = 0;

char cue_chars[34];

SoftwareSerial mySerial0 = SoftwareSerial(0, 1);
SoftwareSerial mySerial1 = SoftwareSerial(3, 2);

void setup() {

  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(8, OUTPUT);

  mySerial0.begin(9600);
  mySerial1.begin(9600);
  // Serial.begin(9600);
  digitalWrite(8, HIGH);
}

void loop() {
  if (cur_cue == -1 || time >= cue_interval / 10) {
    time = 0;
    pickCue();
    handleCueOut();
  }

  time++;
  delay(10);
}

void pickCue() {
  cur_cue = random(60);
  // Serial.println(cur_cue);
  cur_user = !cur_user;
}

void handleCueOut() {

  // clear both screens
  mySerial0.print(0xFE, BYTE);
  mySerial0.print(0x01, BYTE);
  mySerial1.print(0xFE, BYTE);
  mySerial1.print(0x01, BYTE);

  // prepare cue for display
  remixCue(cues[cur_cue]).toCharArray(cue_chars, sizeof(cue_chars));

  // display cue
  if (cur_user) mySerial0.print(cue_chars);
  else mySerial1.print(cue_chars);
}

String werd = String(34);
String remix = String(34);
boolean db;

// This function adds padding to properly print cues that need to break over two lines.
// This might need to change based on size and spec of screens used.

String remixCue(String c) {
  db = false;
  werd = "";
  remix = "";
  if (c.indexOf(" ") != -1 && c.length() > 16)
    db = true;

  if (db)
    werd = c.substring(0, c.indexOf(" "));
  else
    werd = c;

  int e;
  if (werd.length() % 2 == 1)
    e = 1 + (15 - werd.length()) / 2;
  else
    e = (16 - werd.length()) / 2;

  for (int i = 0; i < e; i++)
    remix.concat(" ");
  remix.concat(werd);

  if (db) {
    for (int i = 0; i < (16 - werd.length() - e); i++)
      remix.concat(" ");
    werd = c.substring(c.indexOf(" ") + 1, c.length());
    if (werd.length() % 2 == 1)
      e = 1 + (15 - werd.length()) / 2;
    else
      e = (16 - werd.length()) / 2;

    for (int i = 0; i < e; i++)
      remix.concat(" ");
    remix.concat(werd);
  }
  remix.toUpperCase();
  return remix;
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





