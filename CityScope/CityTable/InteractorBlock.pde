class InteractorBlock extends Block{
  float forceValue = 0.01;
  
  InteractorBlock(PVector _l, int _size, float _forceValue){
    super(_l,_size,color(255,0,255));
    forceValue = _forceValue;
  }
 void run(){
    for (ParticleSystem s :systems){
      PVector force = new PVector((location.x-s.origin.x)*forceValue,(location.y-s.origin.y)*forceValue);
      s.applyForce(force);
    } 
 }
}