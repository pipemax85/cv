class PSystem  
{ 
  float th; 
  PVector ps_loc;   
  ArrayList particles;
  float zP; 
  
  public PSystem(PVector ps_loc, int num, float th)  
  { 
    this.ps_loc = ps_loc; 
    this.th = th; 
    particles = new ArrayList(); 
    for (int i = 0; i < num; i++) { 
      particles.add(new jParticle(new PVector(), new PVector(), new PVector(ps_loc.x, ps_loc.y,ps_loc.z), random(1.0, 70.0))); 
    } 

  } 

  void run(float inx, float iny, float inz, float r) 
  { 
    update(inx,iny,inz,r);     
    for (int i = particles.size()-1; i >= 0; i--) {         
      jParticle prt = (jParticle) particles.get(i); 
      prt.run(inx, iny, inz); 
      //      ps_loc.z = inz+i*10;
      prt.move(new PVector(ps_loc.x,ps_loc.y,ps_loc.z));  
    }
    System.out.println ("inx " + inx + " iny "+ iny + " inz "+ inz + " r "+r +" ps_loc.x " +ps_loc.x+ " ps_loc.y " +ps_loc.y+" ps_loc.z "+ps_loc.z +" th "+th);
    //ellipse(ps_loc.x,ps_loc.y,) VOID VVV
} 
void update(float inx, float iny, float inz,float r)
  { 
    th += 0.0025f; 
    ps_loc.x = inx + r * cos(th); 
    ps_loc.y = iny + r * sin(th); 
    ps_loc.z = inz - r/2;
    ps_loc.x += random(-30.0f, 30.0f); 
    ps_loc.y += random(-30.0f, 30.0f); 
    //    ps_loc.z += random(-30.0f, 30.0f);

  } 
}
