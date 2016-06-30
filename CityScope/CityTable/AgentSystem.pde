public class AgentSystem {
 ArrayList<Agent> agents; 
 AgentSystem(int nbAgent){
   agents = new ArrayList<Agent>();
   /*for (int i = 0; i < nbAgent; i = i+1){
        agents.add(new Agent(i, random(worldWidth), random(worldHeight)));
   }*/
 }
 
 void addAgent(){
   agents.add(new Agent(agents.size(), random(worldWidth), random(worldHeight)));
 }
 void run(){
    for(Agent a : agents) a.update();
    if(!tableau.isEmpty()){
      PVector theRelativeTarget = tableau.getRelativeBlockLocation();
      theRelativeTarget.x = theRelativeTarget.x +  worldWidth/2 - (gridWidth*blockSize)/2 + blockSize/2;
      theRelativeTarget.y = theRelativeTarget.y +  worldHeight/2 - (gridHeight*blockSize)/2 + blockSize/2;   
      for(Agent a : agents){
        a.target= theRelativeTarget;
        a.wander=false;
      }
    }
    ReinitAgent();
 }
 
 void draw(){
    for(Agent a : agents) a.draw();
 }
 void display(){
 }
 
 void ReinitAgent(){
  for(Agent a : agents){
    if(a.arrived == true){
      a.pos = new PVector(random(worldWidth), random(worldWidth));
      a.arrived = false;
      a.wander= true;
    }    
  }
}
  
}
