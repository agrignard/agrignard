class Grid {
  ArrayList<Block> blocks;
  PVector origin;
  int w;
  int h;
  int blockSize;

  Grid(PVector location, int _w, int _h, int _blockSize) {
    origin = location;
    w=_w;
    h=_h;
    blockSize=_blockSize;
    blocks = new ArrayList();
  }
 
  void display(PGraphics p){     
      p.rectMode(CENTER);  
      p.fill(125); 
      //p.rect(origin.x,origin.y,w*blockSize, h*blockSize);
      p.pushMatrix();
      p.translate(origin.x - (blockSize*w)/2, origin.y - (blockSize*h)/2);   
      for (Block b: blocks){
        p.translate(b.location.x*blockSize,b.location.y*blockSize); 
        b.display(p);
        p.translate(-b.location.x*blockSize,-b.location.y*blockSize);
      }
      p.popMatrix();
      
  }
  
    
  /*void update(String file){
    String[] lines = loadStrings(file);
    for (int i=10 ; i<lines.length-1;i++) {
      String[] colSplit1 = split(lines[i], "\t");
      //println(colSplit1[1] + "," + colSplit1[2]);
      addBlock(new PVector(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, Integer.parseInt(colSplit1[0]));
    }
  }*/
  
  void addBlock(PVector _location, int _blockSize, int _id){ 
    blocks.add(new Block(_location, _blockSize, _id));     
  }
  


}

 

 