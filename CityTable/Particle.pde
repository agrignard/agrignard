class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c;

  Particle(PVector l, color _c) {
    acceleration = new PVector(random(-0.01, 0.01),random(-0.01,0.01));
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    lifespan = 255.0;
    c= _c;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan -= 5.0;
  }

  // Method to display
  void display() {
    if(isKeystoned){
     offscreen.stroke(c,lifespan);
     offscreen.fill(c,lifespan);
     offscreen.ellipse(location.x,location.y,8,8); 
    }else{
      stroke(c,lifespan);
      fill(c,lifespan);
      ellipse(location.x,location.y,8,8); 
    }   
  }
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}