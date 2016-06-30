import hypermedia.net.*;
import deadpixel.keystone.*;


Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;


public int displayWidth = 1000;
public int displayHeight = 1000;
public int worldWidth = 500;
public int worldHeight = 500;
public int gridWidth = 5;
public int gridHeight = 5;
public int blockSize = 40;

public boolean isKeystoned = true;
boolean recievingUPDP =false;



ArrayList<ParticleSystem> systems;
Grid grid;

UDPCommunicator udpCommunicator;

void setup() {
  size(displayWidth,displayHeight,P3D);
  //fullScreen(P3D,2);

  //size(displayWidth,displayHeight,P3D);
  udpCommunicator = new UDPCommunicator("localhost",9876); 
    if(isKeystoned){
    ks = new Keystone(this);
    surface = ks.createCornerPinSurface(worldWidth,worldHeight,50); 
    offscreen = createGraphics(worldWidth, worldWidth, P3D);
  }
  systems = new ArrayList<ParticleSystem>();
  grid = new Grid(new PVector(worldWidth/2,worldHeight/2),gridWidth,gridHeight,blockSize);
}

void draw() {
  background(0);
  if(!recievingUPDP){    
     if(isKeystoned){
       offscreen.beginDraw();
       offscreen.clear();
     }
     grid.display();
     grid.run();
     drawExternalData(offscreen);
     if(isKeystoned){ 
      offscreen.endDraw();
      surface.render(offscreen);
     }
  }
}

void drawExternalData(PGraphics p){ 
      int textSize = 20;
      PVector GeneratorPos = new PVector(worldWidth*0.8, worldHeight*0.2);
      p.fill(255);  
      p.textSize(textSize);
      p.textAlign(CENTER); 
      p.text("Generate",GeneratorPos.x,GeneratorPos.y*0.75);
      p.rectMode(CENTER);
  
      p.fill(255);  
      p.rect(GeneratorPos.x, GeneratorPos.y, blockSize, blockSize);
      p.fill(200,0,0);  
      p.rect(GeneratorPos.x, GeneratorPos.y, blockSize/2, blockSize/2);
      
      p.fill(255);  
      p.rect(GeneratorPos.x+blockSize, GeneratorPos.y, blockSize, blockSize); 
      p.fill(0,200,0);  
      p.rect(GeneratorPos.x+blockSize, GeneratorPos.y, blockSize/2, blockSize/2); 
      
      p.fill(255);  
      p.rect(GeneratorPos.x+blockSize*2, GeneratorPos.y, blockSize, blockSize); 
      p.fill(0,0,200);  
      p.rect(GeneratorPos.x+blockSize*2, GeneratorPos.y, blockSize/2, blockSize/2); 
      
      
      PVector AttractPos = new PVector(worldWidth*0.8, worldHeight*0.4);
      p.fill(255);  
      p.textSize(textSize);
      p.textAlign(CENTER); 
      p.text("Attract",AttractPos.x,AttractPos.y*0.85);
      p.rectMode(CENTER);
      
      p.fill(255);  
      p.rect(AttractPos.x, AttractPos.y, blockSize, blockSize);
      p.fill(0,0,0);  
      p.rect(AttractPos.x, AttractPos.y, blockSize/2, blockSize/2);
  
      
      
      PVector RepulsPos = new PVector(worldWidth*0.95, worldHeight*0.4);
      p.fill(255);  
      p.textSize(textSize);
      p.textAlign(CENTER); 
      p.text("Repel",RepulsPos.x,RepulsPos.y*0.85);
      p.rectMode(CENTER);
      
      p.fill(255);  
      p.rect(RepulsPos.x, RepulsPos.y, blockSize, blockSize);
      p.stroke(0);
      p.fill(255,255,255);  
      p.rect(RepulsPos.x, RepulsPos.y, blockSize/2, blockSize/2);
  
     
}



void keyPressed() {

  switch(key) {
    
    case 'c':
    if(isKeystoned){
      ks.toggleCalibration();
    }
    break;
    
    case 'l':
    if(isKeystoned){
      ks.load();
    }
    break; 
    case 's':
    if(isKeystoned){
      ks.save();
    }
    break;
    case '0':
      grid.addBlock(getWorldPositionFromGridPoint(int(random(gridWidth)), int(random(gridHeight))), blockSize, 0);
    break;
    case '1':
      grid.addBlock(getWorldPositionFromGridPoint(int(random(gridWidth)), int(random(gridHeight))), blockSize, 1);
    break;
    case '2':
      grid.addBlock(getWorldPositionFromGridPoint(int(random(gridWidth)), int(random(gridHeight))), blockSize, 2);
      break;
    case '3':
      grid.addBlock(getWorldPositionFromGridPoint(int(random(gridWidth)), int(random(gridHeight))), blockSize, 3);
      break;
    case '4':
      grid.addBlock(getWorldPositionFromGridPoint(int(random(gridWidth)), int(random(gridHeight))), blockSize, 4);
    break;
  }
}


 
 PVector getWorldPositionFromGridPoint(int x, int y){
  return new PVector(worldWidth/2 - (gridWidth/2)*blockSize + x*blockSize, worldHeight/2 - (gridHeight/2)*blockSize + y*blockSize);
}