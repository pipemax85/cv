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
int flockWidth = 1280; //5120
int flockHeight =1280;//640  5120
int flockDepth =1280;//2560
boolean avoidWalls = true;
boolean one = true;
boolean two = false;
 // amount of boids to start the program with
PShader toon;
Frame avatarJelly;
boolean animate = true;

//JELLYFISH
int cantJelly =4;
ArrayList<Jellyfish> flockjelly;
//PShader munchShader;
//JELLYFISH

Graph.Type shadowMapType = Graph.Type.ORTHOGRAPHIC;
Shape[] shapes;
PGraphics shadowMap;
PShader depthShader;
float zNear = 50;
float zFar = flockDepth;
int w = 1000;
int h = 1000;


int zoom;
void setup() {
  size(800, 720, P3D);
  toon = loadShader("ToonFrag.glsl", "ToonVert.glsl");
  toon.set("fraction", 1.0);
  
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.fit();
  // create and fill the list of boids
  
  colorMode(HSB, 360, 100, 100, 100); 
 
  flockjelly = new ArrayList();
  for (int i = 0; i < cantJelly; i++)
    flockjelly.add(new Jellyfish());
  interpolator =  new Interpolator(scene);
  
  scene.setRadius(max(w, h));
  scene.fit(1);
  shapes = new Shape[20];
  for (int i = 0; i < shapes.length; i++) {
    shapes[i] = new Shape(scene) {
      @Override
      public void setGraphics(PGraphics pg) {
        pg.pushStyle();
        if (scene.trackedFrame("light") == this) {
          //Scene.drawAxes(pg, 150);
          pg.fill(0, scene.isTrackedFrame(this) ? 255 : 0, 255, 120);
          //Scene.drawFrustum(pg, shadowMap, shadowMapType, this, zNear, zFar);
        } 
        pg.popStyle();
      }
      @Override
      public void interact(Object... gesture) {
      }
    };
    shapes[i].randomize();
    shapes[i].setHighlighting(Shape.Highlighting.NONE);
  }
  shadowMap = createGraphics(w / 2, h / 2, P3D);
  depthShader = loadShader("depth.glsl");
  depthShader.set("near", zNear);
  depthShader.set("far", zFar);
  shadowMap.shader(depthShader);

  scene.setTrackedFrame("light", shapes[(int) random(0, shapes.length - 1)]);
   scene.trackedFrame("light").setOrientation(new Quaternion(new Vector(0, 0, 1), scene.trackedFrame("light").position()));
}

void draw() {

  float  time = (float) millis();
//  munchShader.set("u_time",time/2000.0);
//  munchShader.set("u_resolution",1280.0,720.0);
//   munchShader = loadShader("munchShader.glsl");
//    shader(munchShader);
  
  background(224, 94, 28);
  
  //shader(toon);
  //background(0);
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  //translate(width/2, height/2);
  sphere(120);
  //background(0);
  //translate(width/2, height/2);
  //rotateY(map(mouseX, 0, width, -PI, PI));
  //rotateX(map(mouseY, 0, height, -PI, PI));
  //scale(10);
  //noFill();
  stroke(0,255,255);
  // box(1); 
  for (float x = 0; x < flockWidth; x+=100) {
    for (float z = 0; z < flockHeight; z+=100) {
      pushMatrix();
      translate(0, flockHeight, 0);
      translate(x, noise(x+100, z+100), z);
      scale(1);
      fill(255*noise(x+100, z+100));
      noStroke();
      box(100);
      popMatrix();
    }
  }
  //sphere(400);
  walls();
  scene.traverse();

  pushStyle();
  strokeWeight(3);
  stroke(255,0,0);
  scene.drawPath(interpolator);
  popStyle();
  
  
  
  //  background(75, 25, 15);
  // 1. Fill in and display front-buffer
 // scene.traverse();
  // 2. Fill in shadow map using the light point of view
  if (scene.trackedFrame("light") != null) {
    shadowMap.beginDraw();
    shadowMap.background(140, 160, 125);
    scene.traverse(shadowMap, shadowMapType, scene.trackedFrame("light"), zNear, zFar);
    shadowMap.endDraw();
    // 3. Display shadow map
    scene.beginHUD();
    image(shadowMap, w / 2, h / 2);
    scene.endHUD();
  }
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

void updateAvatarJelly(Frame frame) {
  if (frame != avatarJelly) {
    avatarJelly = frame;
    if (avatarJelly != null)
      thirdPersonJelly();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

void thirdPersonJelly() {
  
  scene.eye().setReference(avatarJelly);
  //scene.eye().orbit(new Quaternion(new Vector(1, 0, 0), (mouseX - pmouseX) * PI / width), scene.eye());
  scene.fit(avatarJelly, 1);
  //scene.interpolateTo(avatarJelly);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  //updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  scene.track("mouseClicked", mouseX, mouseY);
  //updateAvatarJelly(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
   //scene.track("mouseClicked", mouseX, mouseY);
   //updateAvatar(scene.trackedFrame("mouseClicked"));
   updateAvatarJelly(scene.trackedFrame("mouseClicked"));
   //2. Asynchronously
   //which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
   //scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT){
      // same as: scene.spin(scene.eye());
      scene.spin();
      //scene.cast("mouseDragged", mouseX, mouseY);
      //avatarJelly.orbit(new Quaternion(new Vector(1, 0, 0), (mouseX - pmouseX) * PI / width), scene.eye() );
    }
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.moveForward(mouseX - pmouseX);
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
    else
      avatarJelly.orbit(new Quaternion(new Vector(1, 0, 0), (mouseX - pmouseX) * PI / width), avatarJelly);
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
      scene.fit(1);
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
    //int index = int(random(0,initBoidNum));
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
    else if (avatarJelly != null)
      thirdPersonJelly();
    break;
  case '1':
    one = !one;
    two = !two;
    break;
  }
}
