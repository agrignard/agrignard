public class Agent {
  
  /* <--- ATTRIBUTES --->*/
  private int id;
  // Movement -->
  private PVector target;
  private PVector pos;
  private boolean wander = true,
                  arrived = false;
  private float speed = 0.5;
  
  // Style -->
  private int dotSize = 3;
 
  /* <--- CONSTRUCTOR ---> */
  Agent(int _id, float x, float y) {
    id = _id;
    pos = new PVector(x, y);
  }
  
  public void update(){
    if(wander){
      wander();
    }else{
      if(!arrived) {
        //println("update target vector" + target);
        PVector dir = new PVector( target.x - pos.x, target.y - pos.y );  // Direction to go
        dir.normalize();
        dir.mult(speed);
        pos.add(dir);
        if(pos.dist(target)<10){
          arrived = true;
        }
      }
    }
  }

  public void updateTarget(PVector newTarget) {
    target = newTarget;
    wander = false;
  }
  
  public void wander(){
    /*PVector dir = new PVector( pos.x + random(-1, 1), pos.y + random(-1, 1));
    dir.normalize();
    dir.mult(speed);
    pos.add(dir);  // Direction to go*/
    pos.add( random(-1,1), random(-1,1) , random(-1,1));
  }

  public void draw() {
    if(isKeystoned){
      offscreen.fill(#FFFFFF); noStroke();
      offscreen.ellipse(pos.x, pos.y, dotSize, dotSize);
    }else{
      fill(#FFFFFF); noStroke();
      ellipse(pos.x, pos.y, dotSize, dotSize);
    } 
  }
}
