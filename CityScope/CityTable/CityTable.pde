import hypermedia.net.*;
import deadpixel.keystone.*;

Tiles tableau;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

public String renderingMode = "default"; 
public int screenWidth = 1000;
public int screenHeight = 1000;
public int worldWidth = 500;
public int worldHeight = 500;
public int gridWidth = 5;
public int gridHeight = 5;
public int blockSize = 40;
public float beamerRot = 0;
public boolean drawConfigurationGrid = false;
public boolean drawRealGrid = true;


public boolean isKeystoned = true;
boolean recievingUPDP =false;

AgentSystem agents;

ArrayList<ParticleSystem> systems;
Grid grid;

UDPCommunicator udpCommunicator;

void setup() {
  size(screenWidth,screenHeight,P3D);
  udpCommunicator = new UDPCommunicator(); 
   currentMessage= "";
  tableau = new Tiles(gridWidth,gridHeight,blockSize);
  tableau.types("tiles_custom.tsv");
  udpCommunicator.initUDP("localhost",9876);
  initScreen();
  systems = new ArrayList<ParticleSystem>();
  grid = new Grid(new PVector(worldWidth/2,worldHeight/2),gridWidth,gridHeight,blockSize);
}

void draw() {
  background(0);
  if(!recievingUPDP){    
     if(isKeystoned){
       offscreen.beginDraw();
       offscreen.clear();
       if(drawConfigurationGrid){
         grid.display();
       }
     }
     grid.display();
     grid.run();
     if(isKeystoned){ 
      offscreen.endDraw();
      surface.render(offscreen);
     }
  }
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void initScreen(){   
  if(isKeystoned){
    ks = new Keystone(this);
    surface = ks.createCornerPinSurface(worldWidth,worldHeight,50); 
    offscreen = createGraphics(worldWidth, worldWidth, P3D);
  }
}


void drawScene(boolean isKeystoned){
     if(drawConfigurationGrid){
      offscreen.beginDraw();
      pushMatrix();
      PShape fakeGrid = createShape(RECT, worldWidth/2-(gridWidth*blockSize)/2,worldHeight/2-(gridWidth*blockSize)/2,gridWidth*blockSize,gridWidth*blockSize);
      offscreen.shape(fakeGrid);
      popMatrix();
      offscreen.endDraw();
      surface.render(offscreen);
     }else{
       drawGrid(isKeystoned);
     }     
}
void drawGrid(boolean isKeystoned){  
  if(isKeystoned){
    offscreen.beginDraw();
    offscreen.clear();
    //agents.draw();
    pushMatrix();
    tableau.draw(worldWidth/2, worldHeight/2, drawRealGrid); 
    popMatrix();
    offscreen.endDraw();
    surface.render(offscreen);
  }
  else{
    agents.draw();
    pushMatrix();
    tableau.draw(worldWidth/2, worldHeight/2, drawRealGrid); 
    popMatrix();
  }
}

void updateABM(){

}

/*void initAgent(int nbAgent){
  
  for (int i = 0; i < nbAgent; i = i+1){
        agents.add(new Agent(i, random(worldWidth), random(worldHeight)));
  }
}*/

PVector getWorldPositionFromGridPoint(int x, int y){
  return new PVector(worldWidth/2 - (gridWidth/2)*blockSize + x*blockSize, worldHeight/2 - (gridHeight/2)*blockSize + y*blockSize);
}

void keyPressed() {
  if(str(key).equals("0")||str(key).equals("1")||str(key).equals("2")|str(key).equals("3")){
    tableau.clearTile();
    tableau.createTile(Integer.parseInt(str(key)), int(random(4)), int(random(4)), 0);
  }
  switch(key) {
    case 'd':
      renderingMode = "default";
      break;
    case 't':
      renderingMode = "texture";
    break;

    case 'c':
    if(isKeystoned){
      ks.toggleCalibration();
      drawConfigurationGrid = !drawConfigurationGrid;
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
    case 'r':
      ParticleSystem psRed = new ParticleSystem(new PVector(random(width),random(height)),"red");
      systems.add(psRed);
    break;
    case 'g':
      ParticleSystem psGreen = new ParticleSystem(new PVector(random(width),random(height)),"green");
      systems.add(psGreen);
    break;
    case 'b':
      ParticleSystem psBlue = new ParticleSystem(new PVector(random(width),random(height)),"blue");
      systems.add(psBlue);
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







