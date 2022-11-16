int ledPin[] = {9, 8, 7, 6, 5, 4, 3, 2}; // relay controlling pins
int switchPin[] = {38, 40, 42, 44, 46, 48, 50, 52}; // switch measurement pins
int an[8]; //result of switch measurement pins
int store[] = {1, 1, 1, 1, 1, 1, 1, 1}; // stores prevous switch results; default 1
int statu[8];  // current valve status

void setup() {
  for (byte i = 0; i < 8; i = i + 1) {
    pinMode(ledPin[i], OUTPUT);  // sets the digital pin 13 as output
    digitalWrite(ledPin[i], HIGH);
    statu[i] = 1;
  }

  for (byte i = 0; i < 8; i = i + 1) {
    pinMode(switchPin[i], INPUT_PULLUP);    // sets the digital pins as input pull up
  }

  Serial.begin(115200);

}


int updateStatus() {
  int stat = statu;
  return stat;
}

void loop() {

  bool event = false;
  bool ok = false;
  int datainput[8] = {0, 0, 0, 0, 0, 0, 0, 0};
  int valveinput[8] = {0, 0, 0, 0, 0, 0, 0, 0};
  int start = false;

  // for debugging:
  //   Serial.println("read");
  //  Serial.println(an);
  //  Serial.println("store");
  //  Serial.println(store);
  // Serial.println("status");
  // Serial.println(statu);

  delay(100);

  // information received from serial communication with PC
  if  (Serial.available() != 0) {


    // int cc = 0;
    char firstchar = Serial.read();

    if ( firstchar == 'g') { // get request --> send valve status to computer
      event = true;
      // Serial.print("here");
      Serial.flush();
    }

    if (firstchar == 's') { // set request --> apply valave state
      // while (Serial.available() > 0) {

      //   if (firstchar) == 's') { // set request --> apply valave state
      //      start=true;
      //Serial.print("here");
      //   }

      while (Serial.available() > 0) {
        int tmp = Serial.parseInt();
        valveinput[tmp - 1] = 1;
        datainput[tmp - 1] = Serial.parseInt();

        // cc = cc + 1;

        if (Serial.read() == '\n') {

//          for (byte i = 0; i < 8; i = i + 1) {
//            Serial.print(valveinput[i]);
//          }
//          Serial.println("");
//           for (byte i = 0; i < 8; i = i + 1) {
//           Serial.print(datainput[i]);
//           }
            
          for (byte i = 0; i < 8; i = i + 1) {
            if (valveinput[i] == 1) { // user requested valve switch
              if (datainput[i] == 1) {
                digitalWrite(ledPin[i], HIGH);
                statu[i] = 1;
              } else {
                //   Serial.println(ledPin[i]);
                digitalWrite(ledPin[i], LOW);
                statu[i] = 0;
              }
              ok = true;
            }
          }
          Serial.flush();
        }
      }
    }
  }

  // user manually switching valves

  for (byte i = 0; i < 8; i = i + 1) {
    an[i] = digitalRead(switchPin[i]);


    if (an[i] == 0 && store[i] == 1) {
      // user pressed switch
      event = true;
      if (statu[i] == 1) {
        digitalWrite(ledPin[i], LOW);
        statu[i] = 0;
      } else
      {
        digitalWrite(ledPin[i], HIGH);
        statu[i] = 1;
      }
    }

    // updates memory of pushed button
    store[i] = an[i];
  }


  if (event == true) {
    //sends new status to serial port
    Serial.print("Status:");
    for (byte i = 0; i < 8; i = i + 1) {
      Serial.print(statu[i]);
    }
    Serial.print("\n");
  }

  if (ok == true) { // acknowledgement of command
    Serial.print("OK");
    Serial.print("\n");
  }

}
