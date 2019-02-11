/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid underivada the mouse will be colored blue. If you click on a boid it will
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
//flock bounding box
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;
Interpolator interpolator;
ArrayList<Boid> flockCurves=new ArrayList();
ArrayList<Vector> curves =new ArrayList();

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
  interpolator = new Interpolator(scene);
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  sceneDrawPath();
  CubicCurves();
  if(!curves.isEmpty() ){        
  for(int i=0;i<curves.size()-1;i++){

    beginShape(LINES);
    strokeWeight(4);
    stroke(255,255,0);
    vertex(curves.get(i).x(), curves.get(i).y(), curves.get(i).z());
    vertex(curves.get(i+1).x(), curves.get(i+1).y(), curves.get(i+1).z());
    endShape();
  }}
}

void sceneDrawPath(){
   pushStyle();
   strokeWeight(3);
   stroke(255,0,0);
   scene.drawPath(interpolator);
   popStyle();
}

void CubicCurves ()
{
  flockCurves.clear();
  for(int i = 0; i < 8; i++){
    flockCurves.add(flock.get(i));
  }
  
    curves.clear();
    int n=4;
    int NUM_PTOS=12;
    int i, j, m;
    int xp, yp , zp;
    double [] ax = new double [NUM_PTOS], bx= new double [NUM_PTOS], 
    cx = new double [NUM_PTOS], dx = new double [NUM_PTOS], ay = new double [NUM_PTOS], 
    by = new double [NUM_PTOS], cy = new double [NUM_PTOS], az= new double [NUM_PTOS],
    bz= new double [NUM_PTOS], cz= new double [NUM_PTOS], dy= new double [NUM_PTOS], 
    dz= new double [NUM_PTOS], derivada= new double [NUM_PTOS], gamma= new double [NUM_PTOS], omega = new double [NUM_PTOS];    
    double t, dt;
    //intervals
    m = n-1;
    // gamma
    gamma[0] = .5;
    for (i=1; i<m; i++) 
    {
      gamma[i] = 1./(4.-gamma[i-1]);
    }
    gamma[m] = 1./(2.-gamma[m-1]);
    
    
    //omega para X 
    omega[0] = 3.*(flockCurves.get(1).position.x()-flockCurves.get(0).position.x())*gamma[0];
    for (i=1; i<m; i++) 
    {
      omega[i] = (3.*(flockCurves.get(i+1).position.x()-flockCurves.get(i-1).position.x())-omega[i-1])*gamma[i];
    }
    omega[m] = (3.*(flockCurves.get(m).position.x()-flockCurves.get(m-1).position.x())-omega[m-1])*gamma[m];
    //derivada en los puntos de x
    
    derivada[m]=omega[m];
    for (i=m-1; i>=0; i=i-1) 
    {
      derivada[i] = omega[i]-gamma[i]*derivada[i+1];
    }
    /* Sustituimos gamma, omega y la primera derivada
    para calcular los coeficientes a, b, c y d */
    for (i=0; i<m; i++) {
      ax[i] = flockCurves.get(i).position.x();
      bx[i] = derivada[i];
      cx[i] = 3.*(flockCurves.get(i+1).position.x()-flockCurves.get(i).position.x())-2.*derivada[i]-derivada[i+1];
      dx[i] = 2.*(flockCurves.get(i).position.x()-flockCurves.get(i+1).position.x())+derivada[i]+derivada[i+1];
    }
    
// omega para Y

    omega[0] = 3.*(flockCurves.get(1).position.y()-flockCurves.get(0).position.y())*gamma[0];
    for (i=1; i<m; i++) {
      omega[i] = (3.*(flockCurves.get(i+1).position.y()-flockCurves.get(i-1).position.y())-omega[i-1])*gamma[i];
    }
    omega[m] = (3.*(flockCurves.get(m).position.y()-flockCurves.get(m-1).position.y())-omega[m-1])*gamma[m];
    
    
 //Derivada en y
    derivada[m]=omega[m];
    
    for (i=m-1; i>=0; i=i-1){ 
      derivada[i] = omega[i]-gamma[i]*derivada[i+1];
    }
// coeficientes a, b, c y d en eje Y 
    for (i=0; i<m; i++) {
    ay[i] = flockCurves.get(i).position.y();
    by[i] = derivada[i];
    cy[i] = 3.*(flockCurves.get(i+1).position.y()-flockCurves.get(i).position.y())-2.*derivada[i]-derivada[i+1];
    dy[i] = 2.*(flockCurves.get(i).position.y()-flockCurves.get(i+1).position.y())+derivada[i]+derivada[i+1];
    }
    
// omega para Z 
    omega[0] = 3.*(flockCurves.get(1).position.z()-flockCurves.get(0).position.z())*gamma[0];
    for (i=1; i<m; i++) {
      omega[i] = (3.*(flockCurves.get(i+1).position.z()-flockCurves.get(i-1).position.z())-omega[i-1])*gamma[i];
    }
    omega[m] = (3.*(flockCurves.get(m).position.z()-flockCurves.get(m-1).position.z())-omega[m-1])*gamma[m];
 // la primera derivada
    derivada[m]=omega[m];
    for (i=m-1; i>=0; i=i-1) {
      derivada[i] = omega[i]-gamma[i]*derivada[i+1];
    }
// coeficientes a, b, c y d en eje Y 
    for (i=0; i<m; i++) {
      az[i] = flockCurves.get(i).position.z();
      bz[i] = derivada[i];
      cz[i] = 3.*(flockCurves.get(i+1).position.z()-flockCurves.get(i).position.z())-2.*derivada[i]-derivada[i+1];
      dz[i] = 2.*(flockCurves.get(i).position.z()-flockCurves.get(i+1).position.z())+derivada[i]+derivada[i+1];
    }   
    
// PINTANDO LA CURVA. 
    int NUM_SEG=20;
    dt = 1./(double) NUM_SEG;
    curves.add(new Vector(flockCurves.get(0).position.x(),flockCurves.get(0).position.y(),flockCurves.get(0).position.z()));  

    for (i=0; i<m; i++) {
      for (j=1, t=dt; j<NUM_SEG; j++, t+=dt) {
        xp = (int) (ax[i]+bx[i]*t+cx[i]*t*t+dx[i]*t*t*t);
        yp = (int) (ay[i]+by[i]*t+cy[i]*t*t+dy[i]*t*t*t);
        zp = (int) (az[i]+bz[i]*t+cz[i]*t*t+dz[i]*t*t*t);
        curves.add(new Vector(xp,yp,zp));
      }
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

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.interpolateTo(avatar);
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
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
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

void keyPressed() { //<>//
  switch (key) {
  case '+':
    interpolator.addKeyFrame(flock.get(int(random(0,initBoidNum))).frame);
    break;
  case '-':
    if(interpolator.keyFrames().isEmpty())
      break;
    interpolator.removeKeyFrame(0);
    break;
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
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  }
}
