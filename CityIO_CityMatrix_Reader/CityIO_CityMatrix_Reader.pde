import deadpixel.keystone.*;

public int displayWidth = 500;
public int displayHeight = 500;
public int playGroundWidth = 500;
public int playGroundHeight = 500;

CityIO myCityIO;

/*------- CityIO ----------------------------------------------------*/
JSONArray jsonCityIOs;
JSONObject jsonCityIO = new JSONObject();


PlayGround myPlayGround;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
boolean isGridHasChanged=false;

void setup() {
  size(displayWidth,displayWidth,P3D); //<>//
  myCityIO = new CityIO(this);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(playGroundWidth,playGroundHeight,50); 
  offscreen = createGraphics(displayWidth, displayHeight, P3D);
  myPlayGround = new PlayGround(new PVector(playGroundWidth/2,playGroundHeight/2), playGroundWidth,playGroundWidth);
}
 
void draw() {
  offscreen.beginDraw();
  if (frameCount % 30 == 0){
      jsonCityIO = myCityIO.GetJSONGrid(0);
  } 
  offscreen.clear();
  myPlayGround.display(offscreen);
  offscreen.endDraw();
  surface.render(offscreen); 
}