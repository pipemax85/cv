class Jellyfish {
  
public Frame frame;
// fields
float jxSpeed, jySpeed, jzSpeed, jxRot,jyRot,jzRot;
int numSystems = 40; 
PSystem[] ps = new PSystem[numSystems]; 
float inx, iny, inz; 

float inxini, inyini, inzini; 

Vector position;

float theta, theta2 = 0.0f; 
float amplitude;   
float x, y,z; 
float r; 

float rotx,roty;
int bounds = 1000;
float jx,jy,jz;

boolean moveinx;
boolean moveiny;
boolean moveinz;

boolean moveinxrev = false;
boolean moveinyrev = false;
boolean moveinzrev = false;

Jellyfish() {
  inx = 0; 
  iny = 0; 
  
  for(int i=0; i<numSystems; i++){ 
    // dispose PSystems in a circle 
    x = r * cos(theta); 
    y = r * sin(theta); 
    z = 1;
    x += inx; 
    y += iny;       
    ps[i] = new PSystem(new PVector(x, y, z), 60, theta);  
    theta += 0.16; //0.057,inx,iny,inz,r2;
  } 
  r = 20.0f; //40
  amplitude = r; 
  frame = new Frame(scene) {
    // Note that within visit() geometry is defined at the
    // frame local coordinate system.
    @Override
    public void visit() {
      if (animate)
        run();
      //render();
      //System.out.println ("Visitame ");

    }
  };
  position = new Vector();
  position.set(inx,iny,iny);
  inxini = inx;
  inyini = iny;
  inzini = inz;
  frame.setPosition(position);

  this.jxSpeed = 1;
  this.jySpeed = 1; 
  this.jzSpeed = 1; 
  this.jxRot = random(100, 150);
  this.jyRot = random(100, 150);
  this.jzRot = random(100, 150);

  moveinx = random(1.0, 3.0) <= 1.9;
  moveiny = random(1.0, 3.0) <= 1.9;
  moveinz = random(1.0, 3.0) <= 1.9;
  if (!moveinx && !moveiny && !moveinz){
     if(random(1.0, 3.0) <= 1.5){
       moveinx = true;
     } else if(random(1.0, 3.0) <= 1.5){
       moveiny = true;
     } else {
       moveinz = true;
     }
  }
}


void render(){
 pushStyle();
 
    strokeWeight(2);
    stroke(color(40, 255, 40));
    fill(color(0, 255, 0, 125));
 
     if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 255, 255));
      fill(color(0, 255, 255));
    }  
    
        // highlight avatar
    if (frame ==  avatarJelly) {
      stroke(color(255, 255, 255));
      fill(color(255, 255, 255));
    }

 //draw boid
    beginShape(TRIANGLES);
    int sc = 3;
    if(one){
      vertex(2 * sc, 0, 2 * sc);     //  6, 0,6
      vertex(0, 0, 3 * sc);          //  0, 0,9
      vertex(0, sc, 2 * sc);         //  0, 3,6
      
      vertex(2 * sc, 0, 2 * sc);     //  6, 0,6
      vertex(0, 0, 3 * sc);          //  0, 0,9
      vertex(0, -sc, 2 * sc);        //  0,-3,6
      
      vertex(2 * sc, 0, 2 * sc);     //  6, 0,6
      vertex(0, 0, sc);              //  0, 0,3
      vertex(0, sc, 2 * sc);         //  0, 3,6
      
      vertex(2 * sc, 0, 2 * sc);     //  6, 0,6
      vertex(0, 0, sc);              //  0, 0,3
      vertex(0, -sc, 2 * sc);        //  0,-3,6 
      
      vertex(-5 * sc, 0, 2 * sc);    //-15, 0,0
      vertex(0, 0, 3 * sc);          //  0, 0,9
      vertex(0, sc, 2 * sc);         //  0, 3,6
      
      vertex(-5 * sc, 0, 2 * sc);    //-15, 0,0
      vertex(0, 0, 3 * sc);          //  0, 0,9
      vertex(0, -sc, 2 * sc);        //  0,-3,6
      
      vertex(-5 * sc, 0, 2 * sc);    //-15, 0,0
      vertex(0, 0, sc);              //  0, 0,3
      vertex(0, sc, 2 * sc);         //  0, 3,6
      
      vertex(-5 * sc, 0, 2 * sc);    //-15, 0,0
      vertex(0, 0, sc);              //  0, 0,3
      vertex(0, -sc, 2 * sc);        //  0,-3,6
      
    }
    if(two){
      vertex(3 * sc, 0, 0);          //  9, 0,0
      vertex(-3 * sc, 0, 0);         // -9, 0,0
      vertex(0, 3 * sc, sc);         //  0, 9,3
      
      vertex(3 * sc, 0, 0);          //  9, 0,0
      vertex(-3 * sc, 0, 0);         // -9, 0,0
      vertex(0, 3 * sc, 3 * sc);     //  0, 9,9
      
      vertex(3 * sc, 0, 0);          //  9, 0,0
      vertex(-3 * sc, 0, 0);         // -9, 0,0
      vertex(0, -3 * sc, sc);        //  0, 9,3
      
      vertex(3 * sc, 0, 0);          //  9, 0,0
      vertex(-3 * sc, 0, 0);         // -9, 0,0
      vertex(0, -3 * sc, 3 * sc);    //  0,-9,9
    }
    endShape();
    popStyle();
}

void run() 
{   
  //noSmooth(); 
  waveR(); // cycle and run all the PSystems 
  pushMatrix();
  
  if(moveinx){
    inx = inx + 1;
  }
  if(moveinxrev){
    inx = inx - 1;
  }
  if(moveiny){
    iny = iny + 1;
  }
  if(moveinyrev){
    iny = iny - 1;
  }
  if(moveinz){
    inz = inz + 1;
  }
  if(moveinzrev){
    inz = inz - 1;
  }
  
  position = new Vector();
  position.set(inx,iny,inz+70);
  
  for(int i = 0; i < numSystems; i++) 
    ps[i].run(inxini, inyini, inzini,r);
  frame.setPosition(position);  
   render();
 popMatrix();
  checkBounds();
} 

void waveR() 
{ 
  theta += 0.03;//0.05 
  r = theta; 
  r = sin(r)*amplitude; 
  r += 100; //100
} 

  void checkBounds() {
    if (position.x() > flockWidth){
      position.setX(flockWidth);
      System.out.println ("position.x() > flockWidth");
      moveinx = false;
      moveinxrev = random(1.0, 3.0) <= 1.5;
      moveiny = random(1.0, 3.0) <= 1.5;
      if(!moveiny){
        moveinyrev = random(1.0, 3.0) <= 1.5;
      }
      moveinz = random(1.0, 3.0) <= 1.9;
      if(!moveinz){
        moveinzrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinxrev && !moveiny && !moveinyrev && !moveinz && !moveinzrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinxrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveiny = true;
         } else {
           moveinyrev = true;
         }
      }
    } 
    if (position.x() < 0){
      position.setX(0);
      System.out.println ("position.x() < 0");
      moveinxrev = false; 
      moveinx = random(1.0, 3.0) <= 1.5;
      moveiny = random(1.0, 3.0) <= 1.5;
      if(!moveiny){
        moveinyrev = random(1.0, 3.0) <= 1.5;
      }
      moveinz = random(1.0, 3.0) <= 1.9;
      if(!moveinz){
        moveinzrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinxrev && !moveiny && !moveinyrev && !moveinz && !moveinzrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinxrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveiny = true;
         } else {
           moveinyrev = true;
         }
      }
    }
    if (position.y() > flockHeight){
      position.setY(flockHeight);
      System.out.println ("position.y() > flockHeight");
      moveiny = false;
      moveinyrev = random(1.0, 3.0) <= 1.5;
      moveinx = random(1.0, 3.0) <= 1.5;
      if(!moveinx){
        moveinxrev = random(1.0, 3.0) <= 1.5;
      }
      moveinz = random(1.0, 3.0) <= 1.9;
      if(!moveinz){
        moveinzrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinyrev && !moveinx && !moveinxrev && !moveinz && !moveinzrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinyrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveinx = true;
         } else {
           moveinxrev = true;
         }
      }
    }     
    if (position.y() < 0){
      position.setY(0);
      System.out.println ("position.y() < 0");
      moveinyrev = false;
      moveiny = random(1.0, 3.0) <= 1.5;
      moveinx = random(1.0, 3.0) <= 1.5;
      if(!moveinx){
        moveinxrev = random(1.0, 3.0) <= 1.5;
      }
      moveinz = random(1.0, 3.0) <= 1.9;
      if(!moveinz){
        moveinzrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinyrev && !moveinx && !moveinxrev && !moveinz && !moveinzrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinyrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveinx = true;
         } else {
           moveinxrev = true;
         }
      }
      
    }
    if (position.z() > flockDepth){
      position.setZ(flockDepth);
      moveinz = false;
      moveinzrev = random(1.0, 3.0) <= 1.5;
      moveinx = random(1.0, 3.0) <= 1.5;
      if(!moveinx){
        moveinxrev = random(1.0, 3.0) <= 1.5;
      }
      moveiny = random(1.0, 3.0) <= 1.9;
      if(!moveiny){
        moveinyrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinzrev && !moveinx && !moveinxrev && !moveinx && !moveinxrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinzrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveinx = true;
         } else {
           moveinxrev = true;
         }
      }
      System.out.println ("position.z() > flockDepth");
    }    
    if (position.z() < 0){
      position.setZ(0);
      System.out.println ("position.z() < 0");
      moveinzrev = false;
      moveinz = random(1.0, 3.0) <= 1.5;
      moveinx = random(1.0, 3.0) <= 1.5;
      if(!moveinx){
        moveinxrev = random(1.0, 3.0) <= 1.5;
      }
      moveiny = random(1.0, 3.0) <= 1.9;
      if(!moveiny){
        moveinyrev = random(1.0, 3.0) <= 1.5;
      }
      if(!moveinzrev && !moveinx && !moveinxrev && !moveinx && !moveinxrev){
         if(random(1.0, 3.0) <= 1.5){
           moveinzrev = true;
         } else if(random(1.0, 3.0) <= 1.5){
           moveinx = true;
         } else {
           moveinxrev = true;
         }
      }
      
    }
      
  }

}
