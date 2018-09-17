float x,y,z;

void setup() {
size(640, 360, P3D);
background(0);
}

void draw() {
translate(width/2, height/2, 0);
stroke(255);

noFill();

beginShape();
vertex(185,70);
vertex(45,70);
vertex(150,-130);
vertex(120, -130);
vertex(0, 100);
vertex( 200, 100);
//vertex(115,-70);
vertex(133,-45);
//vertex(-100, 100, -100);
//vertex(   0,   0,  100);
endShape();

beginShape();
vertex(45,70);
vertex(75,70);
vertex(150,-80);
vertex( 250, 130);
vertex( 10, 130);
vertex(0, 100);
endShape();

beginShape();
vertex(150,-130);
vertex( 270, 110);
vertex( 250, 130);
endShape();

}
