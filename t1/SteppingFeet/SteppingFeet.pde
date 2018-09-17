float a = 0;

float mover(float a) {
   a = a + 1  ;
  if (a > width) { 
    a = 0; 
  }
  return a;
}

void setup() {
  smooth();
  size(640, 360);
  background(0,0,0);
  //fill(255, 0, 0);
  stroke(255);
  stroke(0);
}

void draw() {
  fill(255,255,255);
  for (int i=0; i < 700 ; i=i+40){
    beginShape();
      vertex(i,0);
      vertex(i,400);
      vertex(i+20,400);
      vertex(i+20,0);
    endShape();
  } 
  fill(0,0,255);
  rect(a, 80, 60, 20);
  a = mover(a);
  fill(255,255,0);
  rect(a,200,60, 20);
}
