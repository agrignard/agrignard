class ParticleRed extends Particle{
  
  ParticleRed(PVector l){
    super(l);
  }
    void display() {
    if(isKeystoned){
     offscreen.stroke(255,0,0,lifespan);
     offscreen.fill(255,0,0,lifespan);
     offscreen.ellipse(location.x,location.y,8,8); 
    }else{
      stroke(255,0,0,lifespan);
      fill(255,0,0,lifespan);
      ellipse(location.x,location.y,8,8); 
    }   
  }
}

