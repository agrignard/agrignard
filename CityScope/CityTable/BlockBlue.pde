class BlockBlue extends Block{
  ParticleSystem psBlue;
  
  BlockBlue(PVector _l, int _size){
    super(_l,_size);
    psBlue = new ParticleSystem(_l,"blue");
    systems.add(psBlue);
  }
 void run(){
    psBlue.applyForce(gravity);
    psBlue.addParticle();
    psBlue.run();
 }
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(0,0,255);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(0,0,255);  
      rect(location.x, location.y, size, size);  
    }  
  }
}
