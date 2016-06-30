class Block {
  PVector location;
  int size;
  PVector gravity;

  Block(PVector l, int _size) {
    location = l.get();
    size = _size;
    gravity = new PVector(0,0.05);
  }
  
  void run(){
  }

  // Method to display
  void display() {  
    if(isKeystoned){
      offscreen.rectMode(CENTER);  
      offscreen.fill(100);  
      offscreen.rect(location.x, location.y, size, size);  
    }
    else{
      rectMode(CENTER);  
      fill(100);  
      rect(location.x, location.y, size, size);  
    }  
  }

}

