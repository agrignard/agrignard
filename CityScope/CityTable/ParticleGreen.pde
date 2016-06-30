class ParticleGreen extends Particle{
  
  ParticleGreen(PVector l){
    super(l);
  }
    void display() {
    if(isKeystoned){
     offscreen.stroke(0,255,0,lifespan);
     offscreen.fill(0,255,0,lifespan);
     offscreen.ellipse(location.x,location.y,8,8); 
    }else{
      stroke(0,255,0,lifespan);
      fill(0,255,0,lifespan);
      ellipse(location.x,location.y,8,8); 
    }   
  }
}

