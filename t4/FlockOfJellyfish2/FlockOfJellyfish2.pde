
/**
* Flock of Jellyfish 
* By Felipe Ramos & Alejandro Sierra
*
* This program is based on: 
* 3D jellyfish created by VJ Fader www.vjfader.com
* based on "anemone" by Giovanni Carlo Mingati http://www.openprocessing.org/visuals/?visualID=1439
* Click and drag your mouseY to Zoom
* mouseX and mouseY rotates.
*/

/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
Interpolator interpolator;
//flock bounding box
int flockWidth = 2560; //5120
int flockHeight =2560;//640  5120
int flockDepth =2560;//2560
boolean avoidWalls = true;
boolean one = false;
boolean two = true;

int initBoidNum = 0; // amount of boids to start the program with

Frame avatar;

Frame avatarJelly;
boolean animate = true;

//JELLYFISH
int cantJelly =4;
ArrayList<Jellyfish> flockjelly;
//JELLYFISH

int zoom;

void setup() {
  size(800, 720, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  
  
  colorMode(HSB, 360, 100, 100, 100); 

 
  flockjelly = new ArrayList();
  for (int i = 0; i < cantJelly; i++)
    flockjelly.add(new Jellyfish(i==0));
  //jelly.init2();
  interpolator =  new Interpolator(scene);
  
}


  

void draw() {
  background(224, 94, 28);
  //ambientLight(128, 128, 128);
  //directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();

  pushStyle();
  strokeWeight(3);
  stroke(255,0,0);
  scene.drawPath(interpolator);
  popStyle();
}




void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

void updateAvatarJelly(Frame frame) {
  if (frame != avatarJelly) {
    avatarJelly = frame;
    if (avatarJelly != null)
      thirdPersonJelly();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  //scene.eye().setReference(avatar);
  //scene.interpolateTo(avatar);
}

void thirdPersonJelly() {
  scene.eye().setReference(avatarJelly);
  scene.interpolateTo(avatarJelly);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fitBallInterpolation();
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  //updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  updateAvatarJelly(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
   scene.track("mouseClicked", mouseX, mouseY);
   //updateAvatar(scene.trackedFrame("mouseClicked"));
   updateAvatarJelly(scene.trackedFrame("mouseClicked"));
   //2. Asynchronously
   //which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
   scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.zoom(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  
  case '+':
    int index = int(random(0,initBoidNum));
    //interpolator.addKeyFrame(flock.get(index).frame);
    break;
  case '-':
    if(interpolator.keyFrames().isEmpty()){
      println(" ¡No hay puntos para eliminar! ");
      break;
    }else{
      //interpolator.purge();
      println(interpolator.keyFrames());
      println(interpolator.keyFrame(0) + " pos: 0");
      interpolator.removeKeyFrame(0);
      println(interpolator.keyFrames());
    }
    
    break;
  
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  case '1':
    one = !one;
    two = !two;
    break;
  }
}
