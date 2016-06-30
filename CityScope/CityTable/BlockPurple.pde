class BlockPurple extends Block{
  float windForce = 0.001;
  
  BlockPurple(PVector _l, int _size){
    super(_l,_size);
  }
 void run(){

    for (ParticleSystem s :systems){
      PVector wind = new PVector((location.x-s.origin.x)*windForce,(location.y-s.origin.y)*windForce);
      s.applyForce(wind);
    }
   
 }
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(255,0,255);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(255,0,255);  
      rect(location.x, location.y, size, size);  
    }  
  }
}
