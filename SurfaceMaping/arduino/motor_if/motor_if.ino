#include <Wire.h>
#include <Adafruit_ADS1X15.h>

//#define Dbg
#define resolution 1
#define dirPinw 4
#define stepPinw 3
#define dirPinL 2
#define stepPinL 5
#define stepsPerRevolution 200*9/360
#define stepnum 3
#define ADS1115SF 0.1875
Adafruit_ADS1115 ads1115;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(dirPinL, OUTPUT);
  pinMode(stepPinL, OUTPUT);
  pinMode(dirPinw, OUTPUT);
  pinMode(stepPinw, OUTPUT);
  ads1115.begin(0x48);
  ads1115.setGain(GAIN_TWOTHIRDS);


}

void loop() {
  while (Serial.available()) {
    String string_msg = Serial.readString();
    int msg = string_msg.toInt();

    int msg100 = msg / 100;
    int temp   = msg - msg100 * 100;
    int msg10  = temp / 10;
    int msg1   = msg % 10;
#ifdef Dbg
    Serial.println(msg100);
    Serial.println(msg10);
    Serial.println(msg1);
#endif

    switch (msg100) {
      case 1: Serial.println("Pong"); break;
      case 2: case2_stepInput(msg10, msg1); break;
      case 3: case3_getread(); break;
      case 4: case4_stepAndRead(msg10, msg1); break;
    }

  }

}
//void serialEvent() {



//}

void case2_stepInput(int direc, int motor) {
  String ip;
  // int direc;
  //Serial.print("C2S1");
  //while(!Serial.available()){};
  // ip = Serial.readString();
  // ip.toInt() == 211 ? direc = HIGH : direc = LOW;
  // Serial.print("C2S2");
  // while(!Serial.available()){};
  // ip = Serial.readString();
  if (motor == 1) {
    DoStep(dirPinw, stepPinw, direc);
  }
  else if (motor == 0) {
    DoStep(dirPinL, stepPinL, direc);
  }
}
void case3_getread() {
  int16_t results = ads1115.readADC_Differential_0_1();
  Serial.println(results);
}

void case4_stepAndRead(int direc, int motor){
  case2_stepInput(direc, motor);
  case3_getread();
  
}
void start_scan(int Width, int Length) {

  double  stepnum_w = Width / resolution ;
  double stepnum_l = Length / resolution;
  int direc;
  for (int i = 0; i < stepnum_w; i++) {

    //define direct value
    i % 2 == 1 ? direc = HIGH : direc = LOW;
    for (int j = 0; j < stepnum_l; j++) {
      DoStep(dirPinw, stepPinw, direc);
    }
    direc = HIGH;
    direc = LOW;
    DoStep(dirPinL, stepPinL, direc);
  }
}

void DoStep(int dirPin, int stepPin, int dir) {



  // Set the spinning direction clockwise:

  //rotation side, high for forword and low for backword (dir)
  digitalWrite(dirPin, dir);
  // Spin the stepper motor 1 revolution slowly:
  for (int i = 0; i < stepsPerRevolution; i++) {
    // These four lines result in 1 step:
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(800);
    digitalWrite(stepPin, LOW);
    delayMicroseconds(800);
  }
  //delay between messure
  delay(500);
}
