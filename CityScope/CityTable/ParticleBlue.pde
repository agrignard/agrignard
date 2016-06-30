class ParticleBlue extends Particle{
  
  ParticleBlue(PVector l){
    super(l);
  }
    void display() {
    if(isKeystoned){
     offscreen.stroke(0,0,255,lifespan);
     offscreen.fill(0,0,255,lifespan);
     offscreen.ellipse(location.x,location.y,8,8); 
    }else{
      stroke(0,0,255,lifespan);
      fill(0,0,255,lifespan);
      ellipse(location.x,location.y,8,8); 
    }   
  }
}

