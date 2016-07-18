class PlayGround {
  PVector location;
  int width;
  int height;
  
  ArrayList<Grid> grids;
  PVector gridSize;
  
  PlayGround(PVector l, int w, int h){
    location=l;
    width=w;
    height=h;
    grids = new ArrayList();
    grids.add(new Grid(location,(int)getGridSize().x,(int)getGridSize().y,20));
  }
  
  void display(PGraphics p){
    if(isGridHasChanged){
      updateGridJSON();
      isGridHasChanged = false;
    }
    
    p.fill(255);  
    p.textSize(10);
    p.text("PlayGround",location.x-width/2,location.y-height*0.52);
    p.rectMode(CENTER);  
    p.rect(playGroundWidth/2, playGroundHeight/2, width, height);
    for(Grid g: grids){
      g.display(p);
    }
    copyright(p);
  }
    
  PVector getGridSize(){
    if(jsonInput.equals("Colortizer")){
      JSONArray packets = jsonColortizer.getJSONArray("packets");
      JSONObject data = packets.getJSONObject(0).getJSONObject("data");
      JSONObject objects = data.getJSONObject("objects");
      JSONObject extents = objects.getJSONObject("gridExtents");
      return new PVector(extents.getInt("x"), extents.getInt("y"));
    }
    if(jsonInput.equals("cityIO")){
      return new PVector(16,16);
    }
    return new PVector(0,0);
  }
  void updateGridJSON(){
    if(jsonInput.equals("Colortizer")){
      JSONArray packets = jsonColortizer.getJSONArray("packets");  
      JSONObject data = packets.getJSONObject(0).getJSONObject("data");
      JSONArray gridsA = data.getJSONArray("grid");
      for(int i=0; i < gridsA.size(); i++) {
        JSONObject grid =  gridsA.getJSONObject(i);
        int rot = grid.getInt("rot");
        int type = grid.getInt("type");
        int x = grid.getInt("x");
        int y = grid.getInt("y");
        grids.get(0).addBlock(new PVector(x, y), 20, type,0);
      }
    }
    if(jsonInput.equals("cityIO")){
      JSONObject data = jsonCityIO.getJSONObject("data");
      JSONArray gridsA = data.getJSONArray("grid");
      for(int i=0; i < gridsA.size(); i++) {
        JSONObject grid =  gridsA.getJSONObject(i);
        int rot = grid.getInt("rot");
        int type = grid.getInt("type");
        int x = grid.getInt("x");
        int y = grid.getInt("y");
        int magnitude = grid.getInt("magnitude");
        grids.get(0).addBlock(new PVector(x, y), 20, type,magnitude);
      }
    }
}

    public void mouseClicked() {}
   
    public void mouseDragged() {}
  
  
    public void keyPressed() {
    // Evaluate key only in CONFIG mode --->
      switch(key) {
         case 'c':
         ks.toggleCalibration();
         break;  
        case 'l':
         ks.load();
         break; 
        case 's':
         ks.save();
        
        /////////////////////DISPLAY MODE /////////////////
        case '0':
          currentDisplayMode = displayModes.get(0);
          break;
        case '1':
          currentDisplayMode = displayModes.get(1);
          break;
        case '2':
          currentDisplayMode = displayModes.get(2);
          break;
        case '3':
          currentDisplayMode = displayModes.get(3);
          break;
        
        case CODED:
          switch(keyCode) {
            case UP:  // ADD row to selected grid
              break;
            case DOWN:  // REMOVE row to selected grid
              break;
            case LEFT:  // REMOVE column to selected grid
              break;
            case RIGHT:  // ADD grid to selected grid
              break;
          }
          break;
        case '+':  // Create new DEFAULT grid
          break;
        case '-':  // Remove SELECTED grid
          break;
      }
    }
    
 void copyright(PGraphics p){
  p.fill(0); 
  p.textAlign(CENTER,CENTER); textSize(20);
  p.text("Abstract CityScope:" + jsonInput + "  " + currentDisplayMode ,playGroundWidth*0.15,playGroundHeight*0.95);
  //p.text(" fps: " + frameRate);
  p.textAlign(CENTER,CENTER); textSize(10);
  //p.text("Arnaud Grignard - 2016 ",playGroundWidth*0.90,playGroundHeight*0.98);
}
}