// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  color c;

  ParticleSystem(PVector _location, color _c) {
    origin = _location;
    particles = new ArrayList<Particle>();
    c = _c;
  }

  void addParticle() {
      particles.add(new Particle(origin,c));
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