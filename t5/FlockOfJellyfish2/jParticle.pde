class jParticle { 
  PVector loc; 
  PVector vel; 
  PVector acc; 
  float ms; 
  float lengthVar;
  


  jParticle(PVector a, PVector v, PVector l, float ms_) { 
    acc = a; 
    vel = v; 
    loc = l; 
    ms = ms_; 
    lengthVar = random (30);

  } 

  Vector run(float inx, float iny, float inz) { 
    update(); 
    render(inx, iny, inz); 
    //    print (counter);
    return new Vector(loc.x,loc.y,loc.z-ms*4);
  } 

  void update() { 
    vel.add(acc); 
    loc.add(vel); 
    acc = new PVector(); 
  } 

  void render(float inx, float iny, float inz) { 
    noStroke(); 
    fill(257, 28, 65, 10);
    float tenticleSize = ms/30 + 1; 
    strokeWeight(tenticleSize);
    stroke(238, 14, 85, 30); 
    point(loc.x,loc.y,loc.z-ms*4); 
    float al = map(vel.mag(), 0, 1.2, .1, 3); 

    stroke(238, 14, 85, al); 
    noFill();
    strokeWeight(1.5);
    if(ms <= 5) {
      bezier(inx,iny,inz+70, loc.x - (inx-loc.x)/20,loc.y - (iny-loc.y)/20,inz+60,loc.x - (inx-loc.x)/3,loc.y - (iny-loc.y)/3,inz-10,loc.x,loc.y,loc.z + lengthVar);
       bezier(loc.x + (inx-loc.x)/1.5,loc.y + (iny-loc.y)/1.5,inz+20, loc.x - (inx-loc.x)/40,loc.y - (iny-loc.y)/40,inz+40,loc.x - (inx-loc.x)/3,loc.y - (iny-loc.y)/3,inz-10,loc.x,loc.y,loc.z + lengthVar);
    }
  }

  void move(PVector target) { 
    acc.add(steer(target)); 
  }     

  PVector getLocation() { 
    return loc; 
  }  

  PVector steer(PVector target) { 
    PVector steer; 
    PVector desired = PVector.sub(target,loc); 
    float d = desired.mag(); 
    desired.normalize(); 
    desired.mult(3.5f); 
    steer = PVector.sub(desired,vel); 
    steer.limit(3.0f); 
    steer.div(ms); 
    return steer; 
  } 
  
} 
