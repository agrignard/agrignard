// A class to describe a Grid made of Blocks

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
    blocks = new ArrayList<Block>();
  }
  
  void addBlock(PVector _location, int _blockSize, int _id){
    if(!isBlockAlreadyCreated(_location)){ 
      if(_id == 0){
        blocks.add(new BlockRed(_location, _blockSize));
      }
      if(_id == 1){
        blocks.add(new BlockGreen(_location, _blockSize));
      }
      if(_id == 2){
        blocks.add(new BlockBlue(_location, _blockSize));
      }
      if(_id == 3){
        blocks.add(new BlockYellow(_location, _blockSize));
      }
      if(_id == 4){
        blocks.add(new BlockPurple(_location, _blockSize));
      }     
    } 
 }
 
 void clear(){
   blocks.clear();
 }
 
 boolean isBlockAlreadyCreated(PVector location){
   for (Block b: blocks) {
      if(b.location.x == location.x && b.location.y == location.y){
        return true;
      }
    }
    return false;
 }
 
 
 
  void update(String message) {
    String[] lineSplit = split(message, "\n");   
    String[] colSplit = split(lineSplit[2], "\t");
    //int width = Integer.parseInt(colSplit[1]);
    //int height = Integer.parseInt(colSplit[2]);
    grid.clear();
    for (int i=10 ; i<lineSplit.length-1;i++) {
    String[] colSplit1 = split(lineSplit[i], "\t");
    if(Integer.parseInt(colSplit1[0]) == 0){
      grid.addBlock(getWorldPositionFromGridPoint(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, 0);
    }
    if(Integer.parseInt(colSplit1[0]) == 1){
      grid.addBlock(getWorldPositionFromGridPoint(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, 1);
    }
    if(Integer.parseInt(colSplit1[0]) == 2){
      grid.addBlock(getWorldPositionFromGridPoint(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, 2);
    }
    if(Integer.parseInt(colSplit1[0]) == 3){
      grid.addBlock(getWorldPositionFromGridPoint(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, 3);
    }
    if(Integer.parseInt(colSplit1[0]) == 4){
      grid.addBlock(getWorldPositionFromGridPoint(Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2])), blockSize, 4);
    }
    }
  }
 

  void run() {
    for (int i = blocks.size()-1; i >= 0; i--) {
      Block b = blocks.get(i);
      b.run();
      //b.display();
    }
  }
  
  void display(){
    if(isKeystoned){
     offscreen.rectMode(CENTER);  
     offscreen.fill(255);  
     offscreen.rect(origin.x, origin.y, blockSize*w, blockSize*h);  
    }else{
      rectMode(CENTER);  
      fill(255);  
      rect(origin.x, origin.y, blockSize*w, blockSize*h);  
    } 
  }
}
