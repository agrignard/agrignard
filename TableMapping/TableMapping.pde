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
  fullScreen(P2D,1);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(playGroundWidth,playGroundHeight, 50);
  offscreen = createGraphics(playGroundWidth,playGroundHeight, P2D);
  files = new ArrayList();
  //files.add("Andorratable/Andorratable.001.png");
  files.add("Andorratable/Andorratable.002.png");
  //files.add("Andorratable/Andorratable.003.png");
  files.add("Andorratable/Andorratable.004.png");
  //files.add("Andorratable/Andorratable.005.png");
  files.add("Andorratable/Andorratable.006.png");
  //files.add("Andorratable/Andorratable.007.png");
  files.add("Andorratable/Andorratable.008.png");
  //files.add("Andorratable/Andorratable.009.png");
  files.add("Andorratable/Andorratable.010.png");
  //files.add("Andorratable/Andorratable.011.png");
  files.add("Andorratable/Andorratable.012.png");
  //files.add("Andorratable/Andorratable.013.png");
  files.add("Andorratable/Andorratable.014.png");
  //files.add("Andorratable/Andorratable.015.png");
  files.add("Andorratable/Andorratable.016.png");
  //files.add("Andorratable/Andorratable.017.png");
  files.add("Andorratable/Andorratable.018.png");
  //files.add("Andorratable/Andorratable.019.png");
  files.add("Andorratable/Andorratable.020.png");
  //files.add("Andorratable/Andorratable.021.png");
  files.add("Andorratable/Andorratable.022.png");
  //files.add("Andorratable/Andorratable.023.png");
  files.add("Andorratable/Andorratable.024.png");
  //files.add("Andorratable/Andorratable.025.png");
  files.add("Andorratable/Andorratable.026.png");
  //files.add("Andorratable/Andorratable.027.png");
  files.add("Andorratable/Andorratable.028.png");
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