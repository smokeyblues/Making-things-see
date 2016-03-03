//my kinect tracker program

/*
  This program is basically like the finds the closest pixel within the range determined by the closestValue variable
  and uses that pixel like the mouseX and mouseY variables that would normally be captured from a mouse. It draws a red circle 
  around the pixel that acts as the cursor.
  
  There three targets displayed to the left of the screen that trigger random filters. Whe you put the cursor inside one
  of these targets, it will trigger a filter on the video image. Oh and this program is also reading the video image from
  the kinect instead of the depth image that Borenstein used in his example. 
*/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

boolean ir = true;
boolean colorDepth = true;
boolean mirror = true;

float closestValue;  
float closestX;      
float closestY;

// create arrays to store recent closest x- and y-coordinates for averaging
int[] recentXValues = new int[3];
int[] recentYValues = new int[3];

// keep track of which is the current value in the array to be changed
int currentIndex = 0;

float circleButtonX, circleButtonY; // position of circle button
float circleButtonSize; // diameter of circle button
color circleButtonColor; // color of circle button 

void setup() {
  size(640, 480, P3D);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  //kinect.enableIR(ir);
  kinect.enableMirror(mirror);
  kinect.enableColorDepth(colorDepth);
  
  circleButtonColor = color(0, 0, 255);
  
}

void draw() {
  // closestValue declares the distance threshold for the tracker.
  closestValue = 1700;
  
  //maybe this gets the depth array from the kinect in Processing3
  int[] depthValues = kinect.getRawDepth();
  // it does!
  
  //for each row in the depth image
  for(int y = 0; y < 480; y++) {
    
    //look at each pixel in the row
    for(int x = 0; x < 640; x++) {
      
      //pull out the corresponding value from the depth map
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];
      
      // if that pixel is the closest one we have seen so far
      if(currentDepthValue > 0 && currentDepthValue < closestValue) {
        //save its value
        closestValue = currentDepthValue;
        
        // and save its position into recent values arrays
        recentXValues[currentIndex] = x;
        recentYValues[currentIndex] = y;
      }
    }
  }
  
  // cycle current index through 0,1,2:
  currentIndex++;
  if(currentIndex > 2) {
    currentIndex = 0;
  }
  
  // closetX and ClosestY become a running average 
  // with currentX and CurrentY
  closestX = (recentXValues[0] + recentXValues[1] + recentXValues[2]) / 3;
  closestY = (recentYValues[0] + recentYValues[1] + recentYValues[2]) / 3;
  
  
  //draw the depth image on the screen
  image(kinect.getVideoImage(), 0, 0);
  fill(0, 0, 250);
  ellipse(75, 75, 100, 100);
  ellipse(200, 75, 100, 100);
  ellipse(75, 200, 100, 100);
  rect(540, 25, 75, 100);
  
  
  //draw a red circle over it,
  //positioned at the X and Y coordinates 
  //we saved of the closest pixel.
  fill(255,0,0);
  textSize(24);
  text("Invert", 40, 85);
  text("Blur", 50, 210);
  textSize(18);
  text("Threshold", 155, 85);
  text("Stop", 560, 75);
  ellipse(closestX, closestY, 25, 25);
  
  if (closestX > 25 && closestX < 125 && closestY > 25 && closestY < 125) {
    filter(INVERT);
  };
  
  if (closestX > 150 && closestX < 250 && closestY > 25 && closestY < 125) {
    filter(THRESHOLD);
  };

  if (closestX > 25 && closestX < 125 && closestY > 150 && closestY < 250) {
  filter(BLUR, 6);
  };
  
  
  if (closestX > 540 && closestX < 615 && closestY > 25 && closestY < 100) {
  noLoop();
  loop();
  background(0);
  };

saveFrame();

};
