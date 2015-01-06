#include <AF_Wave.h>
#include <avr/pgmspace.h>
#include "util.h"
#include "wave.h"

// wave vars
AF_Wave card;
File f;
Wavefile wave;
uint16_t samplerate;
uint8_t i, r;
char c, name[15];
uint8_t tracknum = 0;
int delayTimer = 0;

// cap vars
float average;
float lastAverage;
int count;
int ledPin = 13;
boolean noise = false;

void setup() {

  Serial.begin(9600);      // connect to the serial port
  pinMode(ledPin, OUTPUT);
  count = 0;
  
  waveSetup();
      

}

void loop () {

  handleCap();
  
  if (noise) {
       delayTimer = 0;
    
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
    //    wave.volume = 1;
  }
  
}

void waveSetup(){
  Serial.println("Wave test!");

  pinMode(2, OUTPUT); 
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  
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

void playcomplete(char *name) {
  uint16_t potval;
  uint32_t newsamplerate;
  
  playfile(name);
  samplerate = wave.dwSamplesPerSec;
  while (wave.isplaying) {  
   //   delayTimer++;
   //   if(delayTimer > 3000) 
      handleCap();
      if (!noise){
        //wave.stop();
        wave.volume = 5;
        //Serial.println("5");
      }
      else {
        wave.volume = 1;
       // Serial.println("1");
      }
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

void handleCap(){
  char capval[2];
  char pinval[2] = {1<<PINB0,1<<PINB1};
  
 
  capval[0] = getcap(pinval[0]);
  average+=capval[0];
  if ((count >= 9999)
    || (wave.isplaying && (count >= 9999))) {
   average /= (float)count;
   Serial.print("average: ");
   Serial.println(average);
   if(average-lastAverage>0.15) noise = false;
   //if(average>1.0) digitalWrite(ledPin, HIGH);
   else if (lastAverage-average>0.15) noise = true;
   //else digitalWrite(ledPin, LOW);
   lastAverage = average;
   average = 0;
   count = 0; 
  }
  else {
    count++;
  }  
  
}

// returns capacity on one input pin // pin must be the bitmask for the pin e.g. (1<<PB0) 
char getcap(char pin) {

  char i = 0;
  DDRB &= ~pin;          // input
  PORTB |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PINB & pin) ) break;
  PORTB &= ~pin;         // low level
  DDRB |= pin;           // discharge
  return i;

} 
