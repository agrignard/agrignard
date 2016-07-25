import hypermedia.net.*;

int PORT=9876; 
String IP="localhost"; 
UDP udp;
String currentMessage = "";

public class UDPCommunicator{
  UDPCommunicator(String _IP, int _PORT){
    IP = _IP;
    PORT= _PORT;
    udp= new UDP(this,PORT,IP);
    udp.listen(true);
    //super.start(); 
  }
  
  void receive(byte[] data, String HOST_IP, int PORT_RX) {
    recievingUPDP = true;
    String _message = new String(data);
    if(!currentMessage.equals(_message)){
       currentMessage =_message;
        grid.update(_message);
    }
    recievingUPDP = false;
  }
  
  void sendData(String message, String IP, int PORT){
      udp.send( message, IP, PORT );
  }
}