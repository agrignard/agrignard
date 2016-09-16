import deadpixel.keystone.*;
import processing.video.*;
import java.io.File;


public int displayWidth = 2000;
public int displayHeight = 1000;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

File folder;
String [] filenames;
String dataFolder = "Marakkech";

PImage bg;
Movie myMovie;
ArrayList<String> files;
int curFile;
boolean isCurFileMovie = false;

float startTime, currTime;
float hitTime = 10000;
boolean isPaused = false;


void setup() {
  size(displayWidth, displayHeight, P3D);
  //fullScreen(P2D,1);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(displayWidth,displayHeight, 50);
  offscreen = createGraphics(displayWidth,displayHeight, P2D);
  folder = new java.io.File(dataPath(dataFolder));
  files = new ArrayList();
  for(int i = 0; i < folder.list().length; i++)
  {
    if(folder.list()[i].endsWith(".jpg") || folder.list()[i].endsWith(".jpeg") || folder.list()[i].endsWith(".png") )  {
       files.add(dataFolder + "/"+ folder.list()[i]);
    }
  }
  curFile = 0;
  loadcurFile(files.get(curFile));
  startTime = millis();
}

void draw() {
  offscreen.beginDraw();
  offscreen.clear();
  if(isCurFileMovie){
    offscreen.image(myMovie,0,0,displayWidth,displayHeight);
  }else{
    offscreen.image(bg,0,0,displayWidth,displayHeight);
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