

 // Define width and Length:
#define resolution 1
#define dirPinw 2
#define stepPinw 3
#define dirPinL 4
#define stepPinL 5
#define stepsPerRevolution 200*120/360
#define stepnum 3
void setup(){
  pinMode(dirPinL, OUTPUT);
  pinMode(stepPinL, OUTPUT);
  pinMode(dirPinw, OUTPUT);
  pinMode(stepPinw, OUTPUT); 
  int Width=10;
  int Length=20;
  start_scan( Width, Length);
}
void loop(){

  
  //my_step(dirPinw, stepPinw, HIGH);
  
}
 
void start_scan(int Width,int Length) {
 

double  stepnum_w = Width/resolution ;
double stepnum_l = Length/resolution;
int direct;
for (int i = 0; i < stepnum_w; i++) {
  
  //define direct value
  if (i%2==1) {
  direct=HIGH;
  }
  else {
  direct=LOW;
  }
  for (int j = 0; j < stepnum_l; j++) {
  my_step(dirPinw, stepPinw, direct);
  }

  direct=HIGH;
  
  my_step(dirPinL, stepPinL, direct);
}
}



/*control a stepper motor with TB6600 stepper motor driver and Arduino without a
library: number of revolutions, speed and direction */



 





void my_step(int dirPin, int stepPin, int dir) {

  
  
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
