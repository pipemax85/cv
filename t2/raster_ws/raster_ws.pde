import frames.timing.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

int antialiasing_subdiv = 8;
float inv_antialiasing_subdiv = (float)1/antialiasing_subdiv;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

float[] colR = {1, 0, 0};
float[] colG = {0, 1, 0};
float[] colB = {0, 0, 1};

void setup() {
  //use 2^n to change the dimensions
  size(1024, 1024, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
      public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

int maximo(float a, float b, float c){
  float maximo =  (a > b)? a:b;
  return int ((maximo  > c)? maximo:c);
}

int minimo(float a, float b, float c){
  float minimo =  (a < b)? a:b;
  return int ((minimo < c)? minimo:c);
}

int[] arriba(){
  int[] top = new int[2];
  top[0] = minimo((float)v1.x(),(float)v2.x(),(float)v3.x());
  top[1] = minimo((float)v1.y(),(float)v2.y(),(float)v3.y());
  return top;
}

int[] derecha(){
  int[] right = new int[2];
  right[0] = maximo((float)v1.x(),(float)v2.x(),(float)v3.x());
  right[1] = maximo((float)v1.y(),(float)v2.y(),(float)v3.y());
  return right;
}

void debug(){
    if (!debug) {
      return;
    }
    pushStyle();
    stroke(255, 0, 0);
    point(round(frame.location(v1).x()), round(frame.location(v1).y()));
    stroke(0, 255, 0);
    point(round(frame.location(v2).x()), round(frame.location(v2).y()));
    stroke(0, 0, 255);
    point(round(frame.location(v3).x()), round(frame.location(v3).y()));
    popStyle();
}
float orientacion(Vector a, Vector b, Vector c) {
  return ((b.x() - a.x()) *  (c.y() - a.y())) - ((b.y() - a.y()) *  (c.x() - a.x()));
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea
  int[] top = arriba();
  int[] right = derecha();
  float powapl =  pow(2, n);
  for (float y = top[1]; y <= right[1]; y = y + powapl) {
    for (float x = top[0]; x <= right[0]; x = x + powapl) {
      Vector p = new Vector(x, y);
      Vector PromedioColor = new Vector(0, 0, 0);
      float W3 = orientacion(v1, v2, p);
      float W1 = orientacion(v2, v3, p);
      float W2 = orientacion(v3, v1, p);
      if (W1 >= 0 && W2 >= 0 && W3 >= 0) {
        float awgP = 255/(W1 + W2 + W3);
        PromedioColor.setX(PromedioColor.x() + W1*awgP);
        PromedioColor.setY(PromedioColor.y() + W2*awgP);
        PromedioColor.setZ(PromedioColor.z() + W3*awgP);
        pushStyle();
        noStroke();
        rectMode(CENTER);
        fill(round(PromedioColor.x()), round(PromedioColor.y()), round(PromedioColor.z()), 200);
        rect(frame.location(p).x(), frame.location(p).y(), 0.5, 0.5);
        popStyle();
     }
    }
  }
  debug();
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
