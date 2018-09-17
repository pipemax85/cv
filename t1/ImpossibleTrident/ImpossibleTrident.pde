float x, y, z;

void setup() {
  size(640, 360, P3D);
  background(0);
}

void draw() {
  translate(width/2, height/2, 0);
  stroke(255);

  noFill();

  beginShape();
  vertex(-180, -30);
  vertex(70, -120);
  vertex(150, -40);
  vertex(-100, 50);
  endShape();

  ellipse(-100, 63, 20, 25);
  beginShape();
  vertex(47, -85);
  vertex(47, -60);
  vertex(70, -38);
  endShape();
  ellipse(-143, 21, 21, 26);

  beginShape();
  vertex(47, -60);
  vertex(-143, 7);
  vertex(-143, 7);
  endShape();
  //ellipse(-143, 50, 40, 40);

  beginShape();
  vertex(-180, -5);
  vertex(47, -85);
  vertex(90, -44);
  vertex(-140, 35);
  endShape();

  ellipse(-180, -17, 20, 25);

  beginShape();
  vertex(150, -40);
  vertex(150, -15);
  vertex(-100, 75);
  endShape();
}
