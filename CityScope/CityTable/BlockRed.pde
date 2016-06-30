class BlockRed extends Block{
  ParticleSystem psRed;
  
  BlockRed(PVector _l, int _size){
    super(_l,_size);
    psRed = new ParticleSystem(_l,"red");
    systems.add(psRed);
  }
  
  void run(){
    if(mousePressed){
      PVector wind = new PVector(0.2,0);
      psRed.applyForce(wind);
    }
    psRed.applyForce(gravity);
    psRed.addParticle();
    psRed.run();
  }
  
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(255,0,0);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(255,0,0);  
      rect(location.x, location.y, size, size);  
    }  
  }
}
