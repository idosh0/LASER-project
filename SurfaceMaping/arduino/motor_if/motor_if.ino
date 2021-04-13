void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

}
void serialEvent() {
  while (Serial.available()) {
        String string_msg = Serial.readString();
        int msg = string_msg.toInt();
        switch(msg) {
          case 1:
          Serial.print("1111");
          break;
          case 2:
          Serial.print("Pong");
          break;
          case 3:
          Serial.print("3");
          break;
        }
        
  }
  
}
