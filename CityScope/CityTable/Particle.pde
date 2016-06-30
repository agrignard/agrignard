class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-1,1),random(-2,0));
    location = l.get();
    lifespan = 255.0;
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
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    if(isKeystoned){
     offscreen.stroke(255,lifespan);
     offscreen.fill(255,lifespan);
     offscreen.ellipse(location.x,location.y,8,8); 
    }else{
      stroke(255,lifespan);
      fill(255,lifespan);
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

