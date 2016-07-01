import processing.net.*; //<>//

byte[] byteBuffer = new byte[100*1024];
boolean isConnected = false;
boolean isRequest1Sent = false;
boolean isJSONValid = false;
String curRecievedString = "";
String curJSON;
Client myClientMain;
int displayWidth = 200;
int displayHeight = 200;

void setup() { 
  size(displayWidth, displayHeight); 
  myClientMain = new Client(this, "cityscope.media.mit.edu", 9999);
  String handcheckmessage = "CIOMIT" + (char)0x05 + (char)0x04 + "tab1";
  myClientMain.write(handcheckmessage);
  while (!isConnected){
    connectToserver();
  }
} 

void draw(){
  background(0);
  textAlign(CENTER,CENTER); textSize(10);
  text("Connection: " +  isConnected,displayWidth/2,displayHeight/4);
  if(!isRequest1Sent){
    if(isConnected){
      SendRequest1();
    }
  }
  text("Request 1 sent : " +  isRequest1Sent ,displayWidth/2,displayHeight/3);
  if(isConnected && isRequest1Sent){
    if(!isJSONValid){ //<>//
      if(curRecievedString==null){
        curRecievedString = readCurrentBuffer();
      }
      else{
        curJSON = readCurrentBuffer();
        println("curJSON:" + curJSON);
        if(isValidJSonArray(curJSON)){
          isJSONValid = true;
        }
        else{
          isJSONValid= false;
        }
      }
    }
  }

  text("isJSONValid : " +  isJSONValid ,displayWidth/2,displayHeight/2);
}



boolean isValidJSonArray(String curString){
  try{
    JSONArray json = parseJSONArray(curString); //<>//
    if (json == null) {
      println("JSONArray could not be parsed");
      return false;
    } 
    else {
      //String species = json.getString(1);
      //println(species);
      return true;
    }
  }
  catch (Exception e) {
    e.printStackTrace();
   return false;
  }
}

/*boolean isValidJSonArray(String curString){
  try {
    parseJSONArray(curString);
    return true;
  } 
  catch (Exception e) {
   return false;
  }
}*/

void connectToserver(){
  int byteCount = myClientMain.readBytes(byteBuffer);
  if (byteCount > 0 ) {
    if(byteCount == 3){
      isConnected =true;
    }
  }
}


void SendRequest1(){
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
}


String readCurrentBuffer(){
  int byteCount = myClientMain.readBytes(byteBuffer);
  if (byteCount > 0 ) {
    String myString = new String(byteBuffer);
    return myString;
  } else return null;
 }




public String bytesToHex(byte[] in, int count) {
    final StringBuilder builder = new StringBuilder();
    for(int i = 0; i < count; i++) {
        byte b = in[i];
        builder.append(String.format("%02x", b));
    }
    return builder.toString();
}