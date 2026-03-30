/* P2 Crawdads Code */


//PIN VARIABLES
//the motor will be controlled by the motor A pins on the motor driver


#include <Servo.h>


Servo myServo;  // create a servo object


const int motorPin = 11;   //Servo
const int buttonPin1 = 9;  //Black
const int buttonPin2 = 6;  //Green
const int buttonPin3 = 4;  //Yellow
const int resetPin = 2;    //Red




//Times for resetting
const int resetTime = 1000;
const int NormalQuestionTime = 7000;


//VARIABLES
int correct = false;
long startTime = 0;
int state = 0;
int residualTime = 0;
int questionTime = NormalQuestionTime + residualTime;
int startTimeActivated = 0;


int buttonState1 = 0;
int buttonState2 = 0;
int buttonState3 = 0;
int resetState = 0;


int answered = 0;
int points = 0;
int angle = 90;
bool makeResTime = false;
int resHolder = 0;


void setup() {
  //set the motor control pins as outputs
  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  pinMode(buttonPin3, INPUT);
  pinMode(resetPin, INPUT);
  //Initalize Servo
  myServo.attach(motorPin);
  //Initiate serial output
  Serial.begin(9600);
  Serial.setTimeout(500);
}


void loop() {
  //Let the buttons read
  buttonState1 = digitalRead(buttonPin1);
  buttonState2 = digitalRead(buttonPin2);
  buttonState3 = digitalRead(buttonPin3);
  resetState = digitalRead(resetPin);
  //Initialize different questions


  switch (state) {
    case 0:
      break;
    case 1:
      //Question 1
      question(1);
      break;
    case 2:
      //Question 2:
      question(2);
      break;
    case 3:
      question(3);
      break;
    case 4:
      question(2);
      break;
    case 5:
      question(1);
      break;
    // more questions can follow
    default:
      // If we go past the question amount, then we reset the game
      reset();
      break;
  }
  // If not on the title screen:
  int timing = 0;
  if (state != 0) {
    //Timer
    long currentTime = millis();
    long endTime = startTime + questionTime;
    questionTime = NormalQuestionTime + residualTime;
    // If the answer still isn't correct or time has not yet run out, keep decreasing the glacier
    if (!correct && (endTime - currentTime >= 0)) {
      timing = endTime - currentTime;
      //drive motor forward (positive speed)
      if(timing % 1000 > 240)
      {
        angle = 90;
      }
      else
      {
        angle = 84;
      }
    } else {
      //stop motor
      timing = 0;
      angle = 90;
      answered = true;
      if (endTime - currentTime >= 0 and makeResTime == false and correct) {
        makeResTime = true;
        resHolder = endTime - currentTime;
      }
    }
    // For the final product it needs serial comms to go to matlab.
    if (Serial.available()) {
      char SerCode = Serial.read();
      if (SerCode == 'a') {
        answered = 0;
        state++;
        correct = 0;
        startTimeActivated = 0;
        if (makeResTime) {
          residualTime = resHolder;
          makeResTime = false;
        }
      }
    }
  } else {
    //When they press button 2 game starts
    if (buttonState2 == HIGH) {
      state = 1;
      delay(1000);
    }
  }
  //Print the Question and if they got it right for matlab
  Serial.print("Q:");
  Serial.print(state);
  Serial.print(" A:");
  Serial.print(answered);
  Serial.print(" C:");
  Serial.print(correct);
  Serial.print(" P:");
  Serial.print(points);
  Serial.print(" T:");
  Serial.print(timing);
  Serial.println(" ");
  //If the game needs to be reset for some reason other than the game ending
  if (resetState == HIGH) {
    reset();
  }


  // set the servo position
  myServo.write(angle);
  delay(15);
}


void question(int answer) {
  //If they hit the right button it is marked as correct
  if (buttonState1 == HIGH && answered == 0) {
    if (answer == 1) {
      correct = true;
      answered = 1;
      points++;
    } else {
      correct = false;
      answered = 1;
    }
  } else if (buttonState2 == HIGH && answered == 0) {
    if (answer == 2) {
      correct = true;
      answered = 1;
      points++;
    } else {
      correct = false;
      answered = 1;
    }
  } else if (buttonState3 == HIGH && answered == 0) {
    if (answer == 3) {
      correct = true;
      answered = 1;
      points++;
    } else {
      correct = false;
      answered = 1;
    }
  }
  //say what time the question began at and only change it when there is a new question
  if (startTimeActivated == 0) {
    startTime = millis();
    startTimeActivated++;
  }
}


void reset() {
  //Initiate the start and end points
  long endpoint = millis() + resetTime;
  long startpoint = millis();


  //do a complete reset of the gear track.
  while (endpoint - startpoint >= 0) {
    startpoint = millis();
    //drive motor backward (negative speed)
    myServo.write(97);
  }
  //Restart from title
  state = 0;
  answered = 0;
  points = 0;
  correct = false;
  startTime = 0;
  residualTime = 0;
  startTimeActivated = 0;
  angle = 90;
}
