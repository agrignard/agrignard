// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  String type;

  ParticleSystem(PVector _location, String _type) {
    origin = _location;
    particles = new ArrayList<Particle>();
    type = _type;
  }

  void addParticle() {
    if(type.equals("red")){
      particles.add(new ParticleRed(origin));
    }
    if(type.equals("green")){
      particles.add(new ParticleGreen(origin));
    }
    if(type.equals("blue")){
      particles.add(new ParticleBlue(origin)); 
    }
    if(type.equals("default")){
      particles.add(new Particle(origin));
    }
  }
  
  void applyForce(PVector force){
    for(Particle p : particles){
      p.applyForce(force);
    }
  } 

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
