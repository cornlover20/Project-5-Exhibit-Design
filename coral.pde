import processing.video.*;
import processing.serial.*;

Movie myMovie;
Serial myPort;

int lastKnobValue = 0;
float framesToProgress = 0.3;

void setup() {
  size(1920, 1080);
  myMovie = new Movie(this, "visu.mp4");
  myMovie.loop();
  
  // open a serial port to communicate with Arduino:
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM5", 9600);
  
  // call the movieEvent function every time a new frame is available:
  myMovie.play();
  myMovie.pause();
}

void draw() {
  // read the value of the knob from Arduino:
  if (myPort.available() > 0) {
    int knobValue = Integer.parseInt(myPort.readStringUntil('\n').trim());
    println(knobValue);

    // check if the knob has been turned:
    if (knobValue != lastKnobValue) {
      // progress the video by X number of frames:
      myMovie.jump(myMovie.time() + (knobValue - lastKnobValue) * framesToProgress);
      
      // play the video if the knob is being turned:
      myMovie.play();
    } else {
      // pause the video if the knob is not being turned:
      myMovie.pause();
    }
    
    lastKnobValue = knobValue;
  }
  
  // display the current frame of the video:
  image(myMovie, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}
