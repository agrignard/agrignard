import deadpixel.keystone.*;
import processing.video.*;


public int displayWidth = 2000;
public int displayHeight = 1000;
public int playGroundWidth = displayWidth;
public int playGroundHeight = displayHeight;

Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;
PImage bg;
Movie myMovie;
ArrayList<String> files;
int curFile;
boolean isCurFileMovie = false;

float startTime, currTime;
float hitTime;
boolean isPaused = false;


void setup() {
  //size(displayWidth, displayHeight, P3D);
  fullScreen(P3D,1);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(playGroundWidth,playGroundHeight, 50);
  offscreen = createGraphics(playGroundWidth,playGroundHeight, P3D);
  files = new ArrayList();
  files.add("demo/start.png");
  files.add("demo/Nina_CDR_1.png");
  files.add("demo/Nina_CDR_2.png");
  files.add("demo/french_spain.png");
  files.add("demo/men.png");
  files.add("demo/women.png");
  files.add("demo/Andorra_Lovers_1.png");
  files.add("demo/Andorra_Lovers_2.png");
  files.add("demo/All_consumption.png");
  files.add("demo/Hotel_consumption.png");
  files.add("demo/Yan_R.png");
  files.add("demo/Yan_Y.png");
  files.add("demo/Yan_G.png");
  files.add("demo/Ryan_PEV_1.png");
  files.add("demo/start.png");
  ///files.add("movie/AndorraABM.mov");
  curFile = 0;
  loadcurFile(files.get(curFile));
  hitTime = 10000; 
  startTime = millis();
}

void draw() {
  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.clear();
  if(isCurFileMovie){
    offscreen.image(myMovie,0,0,playGroundWidth,playGroundHeight);
  }else{
    offscreen.image(bg,0,0,playGroundWidth,playGroundHeight);
  } 
  offscreen.endDraw();
  background(0);
  surface.render(offscreen);
  if(isPaused == false){
    currTime = millis() - startTime;
    if( currTime >= hitTime )
    {
      startTime = millis();
      curFile = (curFile+1)% files.size();
      loadcurFile(files.get(curFile));
    }
  }
  
}

void loadcurFile(String fileName){
   if(fileName.endsWith(".png")){
     bg = loadImage(files.get(curFile));
     isCurFileMovie = false;
   }
   if(fileName.endsWith(".mov")){
     myMovie = new Movie(this, files.get(curFile));
     myMovie.loop();
     isCurFileMovie = true;
   }
}
// Called every time a new frame is available to read
/*void movieEvent(Movie m) {
  m.read();
}*/

void keyPressed() {
  switch(key) {
  case ' ':  // pause simulation
      isPaused = !isPaused;
      break;  
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
 case CODED:
        switch(keyCode) {
          case UP: 
            curFile = (curFile+1) % files.size();
            loadcurFile(files.get(curFile));
            break;
          case DOWN:
            if(curFile==0){
              curFile = (files.size()-1)% files.size();
              loadcurFile(files.get(curFile));
            }else{
              curFile = (curFile-1) % files.size();
              loadcurFile(files.get(curFile));
            }
            
            break;
          case LEFT:
            if(curFile==0){
              curFile = (files.size()-1)% files.size();
              loadcurFile(files.get(curFile));
            }else{
              curFile = (curFile-1) % files.size();
              loadcurFile(files.get(curFile));
            }
            break;
          case RIGHT:
            curFile = (curFile+1) % files.size();
            loadcurFile(files.get(curFile));
            break;
        }
        break;
  }
}