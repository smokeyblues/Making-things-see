//my kinect tracker program

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

boolean ir = true;
boolean colorDepth = true;
boolean mirror = true;

int closestValue;  
int closestX;      
int closestY;

// declare global variables for the previous x ad y coordinates
float lastX;
float lastY;

void setup() {
  size(640, 480);
  background(0);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  //kinect.enableIR(ir);
  kinect.enableMirror(mirror);
  kinect.enableColorDepth(colorDepth);
}



void draw() {
  closestValue = 2000;
  
  int[] depthValues = kinect.getRawDepth();

  for(int y = 0; y < 480; y++) {
    for(int x = 0; x < 640; x++) {
      
      //pull out the corresponding value from the depth map
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];

      if(currentDepthValue > 0 && currentDepthValue < closestValue) {

        closestValue = currentDepthValue;
        closestX = x;
        closestY = y;
      }
    }
  }
  
// "linear interpolation" i.e. smooth transition between last point
// and new closest point
float interpolatedX = lerp(lastX, closestX, 0.3f);
float interpolatedY = lerp(lastY, closestY, 0.3f);

  
  //draw the video image on the screen
  // image(kinect.getVideoImage(), 0, 0);
  
    stroke(255,0,0);
    
    // make a thicker line, which looks nicer
    strokeWeight(3);
  
  //draw a line from the previous point to the new closest one
  line(lastX, lastY, interpolatedX, interpolatedY);
  
  // save the closest point as the new previous one
  lastX = interpolatedX;
  lastY = interpolatedY;
}

void mousePressed() {
  // save the image to a file
  // then clear it on the screen
  save("drawing.png");
  background(0);
}