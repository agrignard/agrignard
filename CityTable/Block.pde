class Block {
  PVector location;
  int size;
  color c;
  ParticleSystem ps;

  Block(PVector l, int _size, color _c) {
    location = l.get();
    size = _size;
    c = _c;
    ps = new ParticleSystem(l,c);
    systems.add(ps);
  }
  
  void run(){
    ps.addParticle();
    ps.run();
  }

  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(c);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(100);  
      rect(location.x, location.y, size, size);  
    }  
  }
}