class BlockYellow extends Block{
  float windForce = 0.001;
  
  BlockYellow(PVector _l, int _size){
    super(_l,_size);
  }
 void run(){

    for (ParticleSystem s :systems){
      PVector wind = new PVector((s.origin.x-location.x)*windForce,(s.origin.y-location.y)*windForce);
      s.applyForce(wind);
    }
   
 }
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(255,255,0);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(255,255,0);  
      rect(location.x, location.y, size, size);  
    }  
  }
}
