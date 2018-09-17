float a, b, c, d , e, f, g;

void setup() {
  size(640, 360);
  stroke(255);
  
  e = 60;
  a = 120;
  b = 180;
  c = 240;
  d = 300;
  f = 360;
  g = 420;
}

float mover(float a) {
   a = a - 0.5;
  if (a < 0) { 
    a = height; 
  }
  return a;
}

void draw() {
  background(51);
  line(100, a, 500, a);  
  line(100, b, 500, b);  
  line(100, c, 500, c);  
  line(100, d, 500, d);  
  line(100, e, 500, e); 
  line(100, f, 500, f);  
  a =mover(a);
  b =mover(b);
  c =mover(c);
  d =mover(d);
  e =mover(e);
  f =mover(f);
  g =mover(g);
  beginShape();
    vertex(200,0);
    vertex(200,0);
    vertex(100,400);
  endShape();

  beginShape();
    vertex(400,0);
    vertex(400,0);
    vertex(500,400);
   endShape();
}
