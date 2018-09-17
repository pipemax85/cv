void setup() {
  size(800, 800);  
}  


void draw() {
  if (mousePressed) {

    stroke(255,128,0);
    line(220, 210, 600, 210);
    line(220, 270, 600, 270);    
    
  } else {

    fill(192,192,192);
    line(220, 210, 600, 210);
    line(220, 270, 600, 270);  
  
    stroke(255,128,0);
    fill(255,128,0);

    
    ellipse(240, 240, 60, 60);    
    ellipse(580, 240, 60, 60);

    stroke(192,192,192);
    fill(192,192,192);
    
    ellipse(240, 180, 30, 30);
    ellipse(240, 300, 30, 30);  
    ellipse(180, 240, 30, 30);      
    ellipse(300, 240, 30, 30);      
    ellipse(200, 280, 30, 30);
    ellipse(280, 200, 30, 30);
    ellipse(200, 200, 30, 30);  
    ellipse(280, 280, 30, 30);
    
    ellipse(580, 120, 120, 120);
    ellipse(470, 200, 120, 120);
    ellipse(690, 200, 120, 120);
    ellipse(510, 340, 120, 120);
    ellipse(650, 340, 120, 120);    
  }
}
