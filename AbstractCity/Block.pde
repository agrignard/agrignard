class Block {
  PVector location;
  int size;
  int id;

  Block(PVector l, int _size, int _id) {
    location = l.copy();
    size = _size;
    id= _id;
  }
  
  void run(){
  }

  // Method to display
  void display(PGraphics p) { 
    p.rectMode(CENTER);
    p.fill(id*10);
    p.rect(location.x, location.y, size, size);  
  }
}