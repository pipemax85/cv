import java.util.Map;
import java.util.List;

class Boid {
  public Frame frame;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in a vector datatype
   
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  
  int representation = 1; // 0 is Face vertex , 1 is vertex vertex
  int renderMode = 0; // 0 in inmediate, 1 es retained
  
  List<Face> faceList = new ArrayList<Face>(); //list face-vertex face
  List<Vector> vertexList = new ArrayList<Vector>(); //list face-vertex vertices
  
  Face f1,f2,f3,f4; // tetrahedron faces
  Vector a1, a2, a3, a4;// tetrahedron vertices
  
  PShape shapeBoid;

  Boid(Vector inPos) {
    position = new Vector();
    position.set(inPos);
    frame = new Frame(scene) {
      // Note that within visit() geometry is defined at the
      // frame local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }
    };
    frame.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())), 
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {
    pushStyle();

    // uncomment to draw boid axes
    //scene.drawAxes(10);

    strokeWeight(2);
    stroke(color(40, 255, 40));
    fill(color(0, 255, 0, 125));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 0, 255));
      fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }
    
    
    System.out.println("Representation " + representation);
    System.out.println("renderMode " + renderMode);
        initializeMeshValues();
    createMeshAndRender();
    setNullUnnecesaryReferences();
    if (renderMode == 1){
      display();
    }
  }
  
  public void createMeshAndRender(){
    switch(this.representation){
      
      case 0://Face vertex
        
        Map <Vector, Face[]> neighbor_faces = new HashMap<Vector, Face[]>();
        neighbor_faces.put( vertexList.get(0), new Face[]{f2, f3, f4});
        neighbor_faces.put( vertexList.get(1), new Face[]{f1, f3, f4});
        neighbor_faces.put( vertexList.get(2), new Face[]{f1, f2, f4});
        neighbor_faces.put( vertexList.get(3), new Face[]{f2, f3, f4});            
        
        if(this.renderMode == 1){ //  MODE RETAINED
           PShape shapeFace = createShape();
           shapeFace.beginShape();
           for(Face face : faceList) {
                shapeFace.vertex(face.v1.x(), face.v1.y(), face.v1.z());
                shapeFace.vertex(face.v2.x(), face.v2.y(), face.v2.z());
                shapeFace.vertex(face.v3.x(), face.v3.y(), face.v3.z());
            }
          shapeFace.endShape();
          this.shapeBoid = shapeFace;          
        } else { // MODE INMEDIATE  
           for(Face face : faceList) {
              beginShape(TRIANGLE_STRIP); 
                vertex(face.v1.x(),face.v1.y(),face.v1.z());
                vertex(face.v2.x(),face.v2.y(),face.v2.z());
                vertex(face.v3.x(),face.v3.y(),face.v3.z());
              endShape();
           }             
        }

      break;
      
      case 1: //vertex-vertex
        Map <Integer, Integer[]> neighbors_list = new HashMap<Integer, Integer[]>();
        neighbors_list.put( 0, new Integer[]{1, 2, 3});
        neighbors_list.put( 1, new Integer[]{0, 2, 3});
        neighbors_list.put( 2, new Integer[]{0, 1, 3});
        neighbors_list.put( 3, new Integer[]{0, 1, 2});

        if(this.renderMode == 0){
          for(int current_vertex: neighbors_list.keySet()){
              Integer[] current_neighbors = neighbors_list.get(current_vertex);
              for(int neighbors: current_neighbors){
                  line(vertexList.get(current_vertex).x(), vertexList.get(current_vertex).y(), vertexList.get(current_vertex).z(), vertexList.get(neighbors).x(),vertexList.get(neighbors).y(),vertexList.get(neighbors).z());
              }
          }
        }
        else{
          PShape shapeVertex = createShape();;
          shapeVertex.beginShape(TRIANGLE_STRIP);
          for(int current_vertex: neighbors_list.keySet()){
              Integer[] current_neighbors = neighbors_list.entrySet().iterator().next().getValue();
              for(int neighbors: current_neighbors){
                  shapeVertex.vertex(vertexList.get(current_vertex).x(), vertexList.get(current_vertex).y(), vertexList.get(current_vertex).z());
                  shapeVertex.vertex(vertexList.get(neighbors).x(),vertexList.get(neighbors).y(),vertexList.get(neighbors).z());
              }
          }
          shapeVertex.endShape();       
          this.shapeBoid = shapeVertex;
      }
      break;    
      
    }
    
  }

  void display(){
    shape(shapeBoid);
  }
  
  void setListsToNull(){
    faceList = null;
    vertexList = null;
  }
  
  void setFacesToNull(){
    f1 = null;
    f2 = null;
    f3 = null;
    f4 = null;
   }
   
   void setVertexToNull(){
     a1 = null;
     a2 = null;
     a3 = null;
     a4 = null;
   }
   
  void setNullUnnecesaryReferences(){
    setFacesToNull();
    setVertexToNull();
  }

  void initializeMeshValues(){
      a1 = new Vector(3 * sc, 0, 0);
      a2 = new Vector(-3 * sc, 2 * sc, 0);
      a3 = new Vector(-3 * sc, -2 * sc, 0);
      a4 = new Vector(-3 * sc, 0, 2 * sc);
      addVertexesToList();

      f1 = new Face(a1, a2, a3);
      f2 = new Face(a1, a2, a4);
      f3 = new Face(a1, a4, a3);
      f4 = new Face(a4, a2, a3);
      addFacesToList();
  }

  void addFacesToList(){
      faceList.add(f1);
      faceList.add(f2);
      faceList.add(f3);
      faceList.add(f4);
  }

   void addVertexesToList(){
      vertexList.add(a1);
      vertexList.add(a2);
      vertexList.add(a3);
      vertexList.add(a4);
   }
}
