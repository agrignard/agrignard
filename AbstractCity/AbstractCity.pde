import deadpixel.keystone.*;

public int displayWidth = 1000;
public int displayHeight = 1000;
public int playGroundWidth = 1000;
public int playGroundHeight = 1000;

ArrayList<String> displayModes = new ArrayList();
String currentDisplayMode = "CityMatrix";


String jsonInput = "cityIO";
//String jsonInput = "Colortizer";

JSONObject jsonColortizer;
JSONArray jsonCityIOs;
JSONObject jsonCityIO;

boolean isGridHasChanged = true;


PlayGround myPlayGround;
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
PGraphics onscreen;
PGraphics curScreen;

void setup() {
  size(displayWidth,displayWidth,P3D);
  displayModes.add("CityMatrix");
  displayModes.add("Id");
  displayModes.add("Magnitude");
  displayModes.add("Abstract");
  //fullScreen(P3D,2);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(playGroundWidth,playGroundHeight,50); 
  offscreen = createGraphics(displayWidth, displayHeight, P3D);
  if(jsonInput.equals("Colortizer")){
    jsonColortizer = loadJSONObject("data/Corlortizer.json");
  }
  if(jsonInput.equals("cityIO")){
    jsonCityIOs = loadJSONArray("data/cityIO.json");
    jsonCityIO = jsonCityIOs.getJSONObject(0);
  }
  
  myPlayGround = new PlayGround(new PVector(playGroundWidth/2,playGroundHeight/2), playGroundWidth,playGroundWidth);
}

void draw() {
  
  background(0);
  offscreen.beginDraw();
  offscreen.clear();
  myPlayGround.display(offscreen);
  fill(255);
  offscreen.endDraw();
  surface.render(offscreen);
}


void keyPressed() {
  myPlayGround.keyPressed();
}

void mouseClicked() {
  myPlayGround.mouseClicked();
}

public void mouseDragged() {
  myPlayGround.mouseDragged();
}