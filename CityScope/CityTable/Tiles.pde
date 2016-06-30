final int[] codeColor = new int[] { #FFFFFF, #000000, #FF0000, #FFFF00, #0000FF };

public class Tiles {

  private int[] size;
  private int tileSize;
  private float rotate = 0;
  
  private ArrayList<Type> types;
  private ArrayList<Tile> tiles;
  
  
  Tiles(int x, int y, int _tileSize) {
    size = new int[] {x, y};
    tileSize = _tileSize;
    tiles = new ArrayList<Tile>();
  }
  
  public void types(String file) {
    types = new ArrayList<Type>();
    Table typesTable = loadTable(file, "header,tsv");
    for(TableRow type : typesTable.rows()) {
      int[] patternCode = new int[] { type.getInt("TL"), type.getInt("TR"), type.getInt("BL"), type.getInt("BR") };
        types.add( new Type(type.getInt("ID"), type.getString("TYPE"), patternCode, type.getString("ASPECT"), type.getString("TEXTURE"), type.getString("TEXTURE")) );
    }
  }
  
  public void update(String message) {
    tiles = new ArrayList<Tile>();
    String[] lineSplit = split(message, "\n");   
    //GRID Size
    String[] colSplit = split(lineSplit[2], "\t");
    //int width = Integer.parseInt(colSplit[1]);
    //int height = Integer.parseInt(colSplit[2]);;
    tableau.clearTile();
    for (int i=10 ; i<lineSplit.length-1;i++) {
    String[] colSplit1 = split(lineSplit[i], "\t");
    createTile(Integer.parseInt(colSplit1[0]), Integer.parseInt(colSplit1[1]), Integer.parseInt(colSplit1[2]), Integer.parseInt(colSplit1[3]));
    }
  }
  
  public void initTable(){
    tiles = new ArrayList<Tile>();
  }
    
  
  public void createTile(int UDPid, int x, int y , int rot ){
    Type type = getTypeFromId(UDPid);
    if(type != null) tiles.add( new Tile( tiles.size(), type, x, y, rot, tileSize) );
  }
    
  public void clearTile(){
      tiles.clear();
  }
        
  public void draw(float x, float y, boolean drawRealGrid) {
    if(drawRealGrid){
      if(isKeystoned){
        offscreen.translate(x, y);   
        offscreen.translate( - ( size[0] - 1 ) * tileSize / 2, - ( size[1] - 1 ) * tileSize / 2);
      }
      else{
        translate(x, y);   
        translate( - ( size[0] - 1 ) * tileSize / 2, - ( size[1] - 1 ) * tileSize / 2);
      }
      
      for(Tile tile : tiles) tile.draw(); 
    }        
   }
  
  public boolean isEmpty(){
    for(Tile tile : tiles){
      if (!tile.type.name.equals("-1")) return false;
    }
    return true;
  }
  
  public PVector getRelativeBlockLocation(){
    for(Tile tile : tiles){
      if (!tile.type.name.equals("-1")) return new PVector(tile.pos[0]*tileSize, tile.pos[1]*tileSize);
    }
    return null;
  }
  
  public void rotate( float angle ) {
    rotate += angle;
  }
  
  private Type getType(int[] code) {
    for( Type type : types ) {
      if( type.isCode(code) ) return type;
    }
    return null;
  }
  
  private Type getTypeFromId(int id) {
    for( Type type : types ) {
      if( type.id == id ) return type;
    }
    return null;
  }
}

public class Tile {
  
  public int id;
  public Type type;
  public PShape block;
  public int[] pos;
  public int rotation;
  public int tileSize;
  
  Tile(int _id, Type _type, int _posX, int _posY, int _rotation, int _tileSize) {
    id = _id;
    type = _type;
    pos = new int[] {_posX, _posY};
    rotation = _rotation - 90 ;
    tileSize = _tileSize;
    
    block = createShape(GROUP);
    noStroke();

    if(renderingMode.equals("default")){
      PShape colorCode = createCodeBox(type.code); 
      block.addChild(colorCode);
    }
    
    if(renderingMode.equals("texture")){
      PShape cover = createShape(RECT, -tileSize/2, -tileSize/2, tileSize, tileSize);
      cover.translate(0, 0, 26);
      cover.setTexture(type.texture);
      block.addChild(cover);
    }

    block.rotateZ( radians(-rotation) );
    
  }
  
  public PShape createCodeBox(int[] code) {
    PShape codeBox = createShape(GROUP);
    for(int i=0; i<code.length; i++) {
      PShape iCode = createShape(BOX, tileSize/2, tileSize/2, 5);
      int dX = ( i == 0 || i == 1 ) ? -1 : 1;
      int dY = ( i == 0 || i == 3 ) ? -1 : 1;
      iCode.translate( tileSize/4 * dX, tileSize/4 * dY, 2.5 );
      if(code[i] != -1){
        iCode.setFill(codeColor[ code[i] ]);
        codeBox.addChild(iCode);
      }
      else{
        iCode.setFill(#00FF00);
        codeBox.addChild(iCode);
      }
    }
    return codeBox;
  }
  
  public void draw() {
    if(isKeystoned){
      offscreen.shape(block, pos[0]*tileSize, pos[1]*tileSize);
    }
    else{
      shape(block, pos[0]*tileSize, pos[1]*tileSize);
    }
    
  }

}


public class Type {
  public int id;
  public String name;
  public int[] code;
  public String aspect;
  public String attribute;
  public PImage texture;
  
  Type(int _id, String _name, int[] _code, String _aspect, String _attribute, String _texture) {
    id=_id;
    name = _name;
    code = _code;
    aspect = _aspect;
    attribute = _attribute;
    texture = loadImage( "textures/" + _texture );
  }
  
  public boolean isCode(int[] _code) {
    for(int i=0; i<code.length; i++) {
      if(code[i] != _code[i]) return false;
    }
    return true;
  }
}
