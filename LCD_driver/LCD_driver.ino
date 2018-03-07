#include "ST7565.h"

// pin 9 - Serial data out (SID)
// pin 8 - Serial clock out (SCLK)
// pin 7 - Data/Command select (RS or A0)
// pin 6 - LCD reset (RST)
// pin 5 - LCD chip select (CS)
ST7565 glcd(9, 8, 7, 6, 5);

// The setup() method runs once, when the sketch starts
void setup()   {                
//  Serial.begin(9600);
  Serial.begin(57600);
  glcd.begin(0x18); // initialize and set the contrast to 0x18
//  glcd.begin(0x24); // range: 0~63
//  glcd.begin(0x3F); 
  glcd.clear();
}

//#define LCDWIDTH 128
//#define LCDHEIGHT 64

void loop() {
  if (Serial.available() > 0) {
    uint8_t *buf = glcd.getbuffer();
    glcd.clear();
    Serial.readBytes(buf, LCDWIDTH * LCDHEIGHT / 8);
    glcd.display();
  }
}
