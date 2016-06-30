class BlockGreen extends Block{
  
  ParticleSystem psGreen;
  
  BlockGreen(PVector _l, int _size){
    super(_l,_size);
    psGreen = new ParticleSystem(_l,"green");
    systems.add(psGreen);
  }
  
  void run(){
    psGreen.applyForce(gravity);
    psGreen.addParticle();
    psGreen.run();
  }
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(0,255,0);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(0,255,0);  
      rect(location.x, location.y, size, size);  
    }  
  }
}
