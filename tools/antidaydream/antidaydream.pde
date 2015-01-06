#include <AF_Wave.h>
#include <avr/pgmspace.h>
#include "util.h"
#include "wave.h"

AF_Wave card;
File f;
Wavefile wave;
const int pwPin = 7; // digital pin 7 for reading pulse width from MaxSonar device
long pulse, cm;
const int maxDistance = 80; // maximum distance for testing presence of person

#define redled 9

uint16_t samplerate;

void setup() {
  Serial.begin(9600);
  Serial.println("Wave test!");

  pinMode(2, OUTPUT); 
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(redled, OUTPUT);
  
  
  if (!card.init_card()) {
    putstring_nl("Card init. failed!"); return;
  }
  if (!card.open_partition()) {
    putstring_nl("No partition!"); return;
  }
  if (!card.open_filesys()) {
    putstring_nl("Couldn't open filesys"); return;
  }

 if (!card.open_rootdir()) {
    putstring_nl("Couldn't open dir"); return;
  }

  putstring_nl("Files found:");
  ls();
}

void ls() {
  char name[13];
  int ret;
  
  card.reset_dir();
  putstring_nl("Files found:");
  while (1) {
    ret = card.get_next_name_in_dir(name);
    if (!ret) {
       card.reset_dir();
       return;
    }
    Serial.println(name);
  }
}

uint8_t tracknum = 0;

void loop() { 

    if(getPulse() < maxDistance){
       uint8_t i, r;
       char c, name[15];
    
       card.reset_dir();
       for (i=0; i<tracknum+1; i++) { // scroll through the files in the directory
         r = card.get_next_name_in_dir(name);
         if (!r) { 
           tracknum = 0; // ran out of tracks! start over
           return;
         }
       }
       putstring("\n\rPlaying "); Serial.print(name);
       card.reset_dir(); // reset the directory so we can find the file
       playcomplete(name);
       tracknum++;
    }
}

float getPulse(){
   // MAXSONAR HANDLE
  pinMode(pwPin, INPUT);

  pulse = pulseIn(pwPin, HIGH);

  cm = 2.54*pulse/147;    //147uS per inch
  Serial.print(cm);
  Serial.println("cm");

  return cm;
   
}

void playcomplete(char *name) {
  uint16_t potval;
  uint32_t newsamplerate;
  
  playfile(name);
  samplerate = wave.dwSamplesPerSec;
  while (wave.isplaying) {     
    if (getPulse() > maxDistance){
      wave.stop();
      Serial.println("STOP!");
    }
    delay(500);
  }
  card.close_file(f);
}

void playfile(char *name) {
   f = card.open_file(name);
   if (!f) {
      putstring_nl(" Couldn't open file"); return;
   }
   if (!wave.create(f)) {
     putstring_nl(" Not a valid WAV"); return;
   }
   wave.play();
}

