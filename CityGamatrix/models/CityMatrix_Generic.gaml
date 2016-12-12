
model CityMatrix

//import "./people.gaml"

global  {
	
matrix data <- matrix(my_csv_file);

file my_csv_file <- csv_file("../includes/CityMatrix.csv",",");
list colors <- [rgb(255,255,255),rgb(189,183,107),rgb(0,255,0),rgb(165,42,42)];
list typeOfBlock <-["Residential", "Office", "Green", "Parking", "Road"];
list typeOfResidential <-["MicroUnit", "Regular", "Luxury"];
list typeOfOffice <-["Co-Working", "Regular", "Headquarter"];



int microUnitResidentialFloorNumber;
int regularResidentialFloorNumber;
int luxuryResidentialFloorNumber;
int coWorkingOfficeFloorNumber;
int regularOfficeFloorNumber;
int headquarterOfficeFloorNumber;

init {
  do update;
}

reflex up{
	do update;
}
  
  action update{
  	
  	ask people{
  		do die;
  	}
  	microUnitResidentialFloorNumber <- rnd(10);
    regularResidentialFloorNumber<- rnd(10);
    luxuryResidentialFloorNumber<- rnd(10);
    coWorkingOfficeFloorNumber<- rnd(10);
    regularOfficeFloorNumber<- rnd(10);
    headquarterOfficeFloorNumber<- rnd(10);
  	
  	  ask cityMatrix {
      grid_value <- float(data[grid_x,grid_y]);
      if(grid_value = 1 ){
      	type <- typeOfBlock[rnd(3)];
      	if(type = "Residential"){ // Residential
      	  function <-typeOfResidential[rnd(2)];
      	  if(function = typeOfResidential[0]){
      	  	depth <- microUnitResidentialFloorNumber;
      	  	//target <- one_of(cityMatrix where (each.grid_value = 1));
      	  }
      	  if(function = typeOfResidential[1]){
      	    depth <- regularResidentialFloorNumber;	
      	  }
      	  if(function = typeOfResidential[2]){
      	    depth <- luxuryResidentialFloorNumber;	
      	  }
      	  create people number:depth{
      	  	location <- any_location_in (myself.shape*0.9);
      	  	location <-{location.x, location.y, location.z + myself.depth +1};
      	  	function <-myself.function;
      	  }	
     	} 
      	if(type = "Office"){
      	  function <-typeOfOffice[rnd(2)];
      	  if(function = typeOfOffice[0]){
      	  	depth <- coWorkingOfficeFloorNumber;
      	  }
      	  if(function = typeOfOffice[1]){
      	    depth <- regularOfficeFloorNumber;	
      	  }
      	  if(function = typeOfOffice[2]){
      	    depth <- headquarterOfficeFloorNumber;	
      	  }
      	  create people number:depth{
      	  	location <- any_location_in (myself.shape*0.9);
      	  	location <-{location.x, location.y, location.z + myself.depth +1};
      	  	function <-myself.function;
      	  }	
     	}
     	if(type = "Green" or type= "Parking"){
   	      depth <-0;
        }   	
      }
      else{
      	type <- typeOfBlock[4];
      }     
    }
  }
}

//Grid species representing a cellular automata
grid cityMatrix width:16  height:16{
	rgb color <- #black;
	string function;
	int floorNumber;
    int depth;
    string type;

    aspect base{
    	if(type = "Residential"){
    		color <- colors[0];
    	}
    	if(type = "Office"){
    		color <- colors[1];
    	}
    	if(type = "Green"){
    		color <- colors[2];
    	}
    	if(type = "Parking"){
    		color <- colors[3];
    	}	
    	draw shape color:color border:#black depth:1 + depth;
    }
}


species people skills:[moving]{
	string function;
	point target;

    //Reflex to move the agent 
	reflex move {
		//Make the agent move only on cell without walls
		/*do goto target: target speed: 1 on: (cityMatrix where not each.is_wall) recompute_path: false;
		//If the agent is close enough to the exit, it dies
		if (self distance_to target) < 2.0 {
			do die;
		}*/
	}

	aspect base{
		if(function = "MicroUnit" or function = "Co-Working"){
          color <- #blue;
        }
    	if(function = "Regular"){
    		color <- #yellow;
    	}
    	if(function = "Luxury" or function = "Headquarter"){
    		color <- #red;
    	}
		draw sphere(0.4) color:color;
	}
}



experiment "Game of Life" type: gui {
	/*parameter "microUnitResidentialFloorNumber" var: microUnitResidentialFloorNumber min: 1 max: 1000 init:10;
	parameter "regularResidentialFloorNumber" var: regularResidentialFloorNumber min: 1 max: 1000 init:7;
	parameter "luxuryResidentialFloorNumber" var: luxuryResidentialFloorNumber min: 1 max: 1000 init:5;
	
	parameter "coWorkingOfficeFloorNumber" var: coWorkingOfficeFloorNumber min: 1 max: 1000 init:10;
	parameter "regularOfficeFloorNumber" var: regularOfficeFloorNumber min: 1 max: 1000 init:12;
	parameter "headquarterOfficeFloorNumber" var: headquarterOfficeFloorNumber min: 1 max: 1000 init:2;*/
	

	output {
		display Life type: opengl {
			species cityMatrix aspect:base;
			species people aspect:base;
		}

	}
	
}
