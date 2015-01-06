String cues_1p[22] = {
  "0wish", "0lie", "0reminisce", "0eye contact", "0notice", "0plan", "0criticize", "0laugh", 
  "0make fun", "0care", "0compare", "0listen", "0roll eyes", "0empathize", "0frown", "0predict", 
  "0agree", "0disagree", "0smile", "0dismiss", "0complain", "forget"};
String cues_2p[66] = {
  "0confront", "1charm", "0compliment", "0roll eyes", "0empathize", "0use sarcasm", "0reveal", "1chime in", 
  "0argue", "1relate to", "0brag", "1care", "0challenge", "0eye contact", "0advise", "1complain", 
  "0compare", "1criticize", "0wish", "1accuse", "0dismiss", "0smile", "0change topic", 
  "1empathize", "0lie", "1disagree", "0complain", "0touch", "0plan", "1challenge", "0argue", "1reveal", "0predict", 
  "0shake head", "0question", "1defend", "0share", "1debate", "0confront", "1notice", "0confide", "1brag", 
  "0interrupt", "1agree", "0compliment", "0use sarcasm", "0wish", "1debate", "0roll eyes", 
  "0predict", "0disagree", "1suggest", "0notice", "1change subject", "0compare", "1insult", 
  "0smile", "0confront", "0argue", "1care", "0praise", "1complain", "0question", "1compliment", "0lie", "1defend"};
String cues_3p[90] = {
  "0share", "1accuse", "2critize", "0lie", "1gesture", "1commiserate", "0reveal",
  "0wink", "1brag", "0suggest", "1defend", "2joke", "0change subject", "1agree", "2compliment", "0confront",
  "1commiserate", "1frown", "0complain", "1question", "2lie", "0share", "0shake head", "1disagree", "0wish",
  "1advise", "2praise", "0aggravate", "1chime in", "2care", "0reminisce", "0doubt", "1quote", "0charm",
  "1relate to", "2digress", "0insult", "0clap", "1agree", "0criticize", "0eye contact", "1notice", "0accuse", "1touch",
  "2debate", "0make fun", "1empathize", "2interrupt", "0challenge", "1plan", "2chime in", "0roll eyes", "0praise",
  "1advise", "0quote", "1use sarcasm", "2care", "0debate", "0touch", "1notice", "0listen", "1defend", "2predict",
  "0confide", "1laugh", "2challenge", "0joke", "1hug", "2suggest", "0compliment", "1complain", "2remember",
  "0advise", "0wink", "1lie", "0confide", "1use sarcasm", "1smile", "0change subject", "1challenge", "2charm",
  "0dismiss", "0touch", "1make fun", "0wish", "1brag", "2respond", "0accuse", "0eye contact", "1predict"};
String cues_4p[116] = {
  "0advise", "1argue", "2react", "3laugh", "0insult", "0nod", "1quote", "2interrupt",
  "0commiserate", "0roll eyes", "1use sarcasm", "2plan", "0confide", "0wink", "1notice", "2joke", "0challenge",
  "1question", "2aggravate", "3care", "0brag", "0eye contact", "1reveal", "2accuse", "0confront", "1wish",
  "2advise", "3use sarcasm", "0praise", "0squint", "1defend", "2disagree", "0predict", "1interrupt",
  "1smile", "2share", "0compliment", "0frown", "1digress", "2chime in", "0confide", "1change subject", "1clap",
  "2evade", "0criticize", "1hug", "2suggest", "3laugh", "0debate", "0touch", "1listen", "2make fun", "0complain",
  "1charm", "2compare", "3agree", "0plan", "1disagree", "2joke", "2lean in", "0reminisce", "0shrug", "1aggravate",
  "2wish", "0white lie", "1question", "2compare", "3advise", "0share", "0shake head", "1use sarcasm",
  "2commiserate", "0relate to", "1challenge", "1eye contact", "2care", "0reveal", "0smile", "1debate", "2praise",
  "0argue", "1relate to", "2defend", "3consider", "0laugh", "1digress", "1gesture", "2confide", "0make fun", "0touch",
  "1chime in", "2quote", "0charm", "0frown", "1criticize", "2agree", "0insult", "0wink", "1brag", "2plan", "0suggest",
  "1accuse", "2notice", "3dismiss", "0complain", "0nod", "1chime in", "2confide", "0quote", "1disagree", "1roll eyes",
  "2joke", "0question", "1wish", "2compare", "3charm"};
String cues_greet[6] = {
  "0greet", "0introduce", "0smile", "0wave", "0shake hand", "0hug"};

int max_cues[5] = {
  22, 33, 30, 29, 6};

int cue_time = 1500;
int time = 0;
int num_p = 0;
boolean last_status_p[4] = {
  false, false, false, false};
boolean status_p[4] = {
  false, false, false, false};
int dist_p[40];
int arr = 10;
int group_cur = 0;
int set_cur = 0;
String cues_cur[4], cues_out[4];
int cur_cue = -1;
String cue_temp;

void setup() {
  Serial.begin(115200);
  Serial1.begin(115200);
  Serial2.begin(115200);
  Serial3.begin(115200);

  for (int i=0; i<4; i++) {
    pinMode(i, INPUT);
  }
}

void loop() {

  if (time >= cue_time * (num_p) + 10) { // change this number for reset time needed
    resetCues();
    time = 0;
    cur_cue = -1;
  }

  if (time >= (cur_cue+1) * cue_time) {
    cur_cue++;
    handleCueOut();
  }

  handleSensors();
  time++;
  delay(5);
}

int avg;
void resetCues() {
  // check dist sensors 
  num_p = 0;
  for (int i=0; i<4; i++) {
    avg = 0;
    for (int j=0; j<arr; j++) {
      avg += dist_p[arr*i+j]; 
    }
    avg /= arr;
    //if (i==0) Serial.println(avg);  
    last_status_p[i] = status_p[i];
    if (avg > 150) { 
      num_p++;
      status_p[i] = true;
    }
    else status_p[i] = false;
  }

  // if at least one person, set up cues
  if (num_p > 0) {
    // choose cue group (1p, 2p, 3p, 4p)
    group_cur = random (max(0,num_p-2), num_p);
    // choose cue set
    set_cur = random (max_cues[group_cur]);

    // load cues
    for (int i=0; i<num_p; i++) {
      if (i <= group_cur) {
        if (group_cur == 0)
          cues_cur[i] = cues_1p[set_cur + i]; 
        else if (group_cur == 1)
          cues_cur[i] = cues_2p[set_cur*2 + i]; 
        else if (group_cur == 2)
          cues_cur[i] = cues_3p[set_cur*3 + i]; 
        else if (group_cur == 3)
          cues_cur[i] = cues_4p[set_cur*4 + i]; 
      }
      else cues_cur[i] = ""; // insert blanks for lesser sets 
    }

    // shuffle order for output
    int r;
    for (int a=0; a<num_p; a++) {
      r = random (4);
      cue_temp = cues_cur[a];
      cues_cur[a] = cues_cur[r];
      cues_cur[r] = cue_temp;
    }

    // distribute to screens - walk statuses give out cue if true
    int next = 0;
    for (int s=0; s<4; s++) {
      if (status_p[s]) {
        if (!last_status_p[s]) {
          r = random (max_cues[4]);
          cues_out[s] = cues_greet[r];
        }
        else cues_out[s] = cues_cur[next];
      }
      else cues_out[s] = "";
      next++;
    }
  }  
}

void handleCueOut() {

  //Serial.println(get_free_memory());
  if (cues_out[0].charAt(0)-48 == cur_cue) {
    if (cues_out[0].indexOf(" ") != -1 && cues_out[0].length() > 11) {
      Serial.print(0x7c, BYTE);
      Serial.print(0x19, BYTE);
      Serial.print(0x12, BYTE);
    }
    else {
      Serial.print(0x7c, BYTE);
      Serial.print(0x19, BYTE);
      Serial.print(0x19, BYTE);    
    }
    Serial.print(0x7c, BYTE);
    Serial.print(0x18, BYTE);
    Serial.print(0x4, BYTE);  

    Serial.print(remixCue(cues_out[0]));
  }
  if (cues_out[1].charAt(0)-48 == cur_cue) {    
    if (cues_out[1].indexOf(" ") != -1 && cues_out[1].length() > 11) {
      Serial1.print(0x7c, BYTE);
      Serial1.print(0x19, BYTE);
      Serial1.print(0x12, BYTE);
    }
    else {
      Serial1.print(0x7c, BYTE);
      Serial1.print(0x19, BYTE);
      Serial1.print(0x19, BYTE);    
    }
    Serial1.print(0x7c, BYTE);
    Serial1.print(0x18, BYTE);
    Serial1.print(0x4, BYTE);  
    Serial1.print(remixCue(cues_out[1]));
  }
  if (cues_out[2].charAt(0)-48 == cur_cue) {    
    if (cues_out[2].indexOf(" ") != -1 && cues_out[2].length() > 11) {
      Serial2.print(0x7c, BYTE);
      Serial2.print(0x19, BYTE);
      Serial2.print(0x12, BYTE);
    }
    else {
      Serial2.print(0x7c, BYTE);
      Serial2.print(0x19, BYTE);
      Serial2.print(0x19, BYTE);    
    }
    Serial2.print(0x7c, BYTE);
    Serial2.print(0x18, BYTE);
    Serial2.print(0x4, BYTE);  
    Serial2.print(remixCue(cues_out[2]));
  }
  if (cues_out[3].charAt(0)-48 == cur_cue) {    
    if (cues_out[3].indexOf(" ") != -1 && cues_out[3].length() > 11) {
      Serial3.print(0x7c, BYTE);
      Serial3.print(0x19, BYTE);
      Serial3.print(0x12, BYTE);
    }
    else {
      Serial3.print(0x7c, BYTE);
      Serial3.print(0x19, BYTE);
      Serial3.print(0x19, BYTE);    
    }
    Serial3.print(0x7c, BYTE);
    Serial3.print(0x18, BYTE);
    Serial3.print(0x4, BYTE);  
    Serial3.print(remixCue(cues_out[3]));
  }

  if (cur_cue >= num_p) {
    resetScreens();
  }
}

String werd, remix;
boolean db;
String remixCue(String c) {
  werd = "";
  remix = "";
  db = false;
  if (c.indexOf(" ") != -1 && c.length() > 11) 
    db = true;

  if (db)
    werd = c.substring(1, c.indexOf(" "));
  else
    werd = c.substring(1, c.length());

  int e = 0;
  if (werd.length() % 2 == 0)
    e = 1+(10 - werd.length())/2;
  else
    e = (11 - werd.length())/2;

  for (int i=0; i<e; i++)
    remix.concat(" "); 
  remix.concat(werd);

  if (db) {
    for (int i=0; i<(11-werd.length()-e); i++)
      remix.concat(" "); 
    werd = c.substring(c.indexOf(" ")+1, c.length());
    if (werd.length() % 2 == 0)
      e = 1+(10 - werd.length())/2;
    else
      e = (11 - werd.length())/2;  

    for (int i=0; i<e; i++)
      remix.concat(" "); 
    remix.concat(werd);   
  }
  return remix.toUpperCase();
}

void handleSensors() {
  for (int i=0; i<4; i++) {
    for (int j=0; j<arr-1; j++) { // shift all in array over 1 spot
      dist_p[arr*i+j] = dist_p[arr*i+j+1];
    }
    dist_p[arr*i+arr-1] = analogRead (i); // read new dist
  } 
}


void resetScreens() {
  Serial.print(0x7c, BYTE);
  Serial.print(0x06, BYTE);
  Serial1.print(0x7c, BYTE);
  Serial1.print(0x06, BYTE);
  Serial2.print(0x7c, BYTE);
  Serial2.print(0x06, BYTE);
  Serial3.print(0x7c, BYTE);
  Serial3.print(0x06, BYTE); 
}

extern void *__bss_end;
extern void *__brkval;

int get_free_memory()
{
  int free_memory;

  if((int)__brkval == 0)
    free_memory = ((int)&free_memory) - ((int)&__bss_end);
  else
    free_memory = ((int)&free_memory) - ((int)__brkval);

  return free_memory;
}
