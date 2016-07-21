import processing.net.*; //<>//
class CityIO{
  byte[] byteBuffer = new byte[100*1024];
  boolean isConnected = false;
  boolean isRequest1Sent = false;
  boolean isJSONValid = false;
  String curRecievedString = "";
  String curJSON;
  Client myClientMain;
  int displayWidth = 200;
  int displayHeight = 200;
  JSONArray jsonGrid;

  
  CityIO(PApplet p) { 
    myClientMain = new Client(p, "cityscope.media.mit.edu", 9999);
    String handcheckmessage = "CIOMIT" + (char)0x05 + (char)0x04 + "tab1";
    myClientMain.write(handcheckmessage);
    connectToserver(); // while inside
  } 
  
  JSONObject GetJSONGrid(int id){
    if(!isRequest1Sent){
      if(isConnected){
        SendRequest1(0);
        curJSON = "";
      }
    }
    if(isConnected && isRequest1Sent){
      if(!isJSONValid){ //<>//
        String recv = readCurrentBuffer();
        if(recv.length() > 0) {
          //println("Received " + String.valueOf(recv.length()));
          curJSON += recv;
          if(isValidJSonArray(curJSON)){
            jsonGrid = parseJSONArray(curJSON);
            //isJSONValid = true;
            isRequest1Sent = false;
            println("Success");
            isGridHasChanged = true;
            JSONObject json= null;
            for (int i = 0; i < jsonGrid.size(); i++) {
                json = jsonGrid.getJSONObject(0);
                if (json == null) {
                  println("JSONObject could not be parsed");
                } 
                else {
                }
            }
            return json;
          }
          else{
            isJSONValid= false;
            return null;
          }
        }
      }
      return null;
    }
    else{
      return null;
    }
  }
  
  
  
  boolean isValidJSonArray(String curString){
    try{
      JSONArray json = parseJSONArray(curString); //<>//
      if (json == null) {
        println("JSONArray could not be parsed");
        return false;
      } 
      else {
        return true;
      }
    }
    catch (Exception e) {
      //e.printStackTrace();
     return false;
    }
  }
  
  
  
  void connectToserver(){
    int recievedNumberOfBytes = 0;
    int curByteCount = 0;
    while (!isConnected){
      curByteCount = myClientMain.readBytes(byteBuffer);
      recievedNumberOfBytes = recievedNumberOfBytes+ curByteCount;
      //println("byteCount" + recievedNumberOfBytes);
      if(recievedNumberOfBytes==3){
        isConnected =true;
        println("isConnected" + true);
      }
    }
  }
  
  
  void SendRequest1(int id ){
    JSONArray jsonArrayRequest1 = new JSONArray();
    JSONObject jsonRequest1 = new JSONObject();
    jsonRequest1.setInt("id", 1468397304);
    jsonRequest1.setString("opcode", "get_updates");
    JSONObject data = new JSONObject();
    data.setInt("delta", 0);
    jsonRequest1.setJSONObject("data", data);
    saveJSONObject(jsonRequest1, "data/new.json");
    jsonArrayRequest1.setJSONObject(0, jsonRequest1);
    myClientMain.write(jsonArrayRequest1.toString());
    isRequest1Sent = true;
    println("Sending request");
  }
  
  
  String readCurrentBuffer(){
    int byteCount = myClientMain.readBytes(byteBuffer);
    if (byteCount > 0 ) {
      String myString = new String(byteBuffer, 0, byteCount);
      return myString;
    } else return "";
   }
  

  public String bytesToHex(byte[] in, int count) {
      final StringBuilder builder = new StringBuilder();
      for(int i = 0; i < count; i++) {
          byte b = in[i];
          builder.append(String.format("%02x", b));
      }
      return builder.toString();
  }
}