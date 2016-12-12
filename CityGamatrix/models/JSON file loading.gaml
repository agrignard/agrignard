/**
* Name: JSON File Loading
* Author:  Arnaud Grignard
* Description: Initialize a grid from a JSON FIle. 
* Tags:  load_file, grid, json
*/

model json_loading   

global {
	file JsonFile <- json_file("../includes/cityIO.json");
    map<string, unknown> c <- JsonFile.contents;
    map<int,rgb> peopleColors <-[0::#blue, 1::#yellow, 2::#red,3::#blue, 4::#yellow, 5::#red];
    map<int,rgb> buildingColors <-[0::rgb(189,183,107), 1::rgb(189,183,107), 2::rgb(189,183,107),3::rgb(230,230,230), 4::rgb(230,230,230), 5::rgb(230,230,230)];

	init { 
		list<map<string, int>> cells <- c["grid"];
        loop mm over: cells {                 
            cityMatrix cell <- cityMatrix grid_at {mm["x"],mm["y"]};
            cell.type <-int(mm["type"]);
            if(int(cell.type) = 6){
            	  cell.color <-rgb(20,20,20);   	  
            }else{
              if(int(cell.type) = -1){
            	   cell.color <- (flip(0.5) ? #green : #gray);
            	  }if(int(cell.type) = 0 or int(cell.type) = 1 or int(cell.type) = 2){
            	  cell.color <-buildingColors[int(cell.type)];
            	  create people number:50{
            	  	id <-int(cell.type);
            	  	location <- cell.location + {rnd(-2.0,2.0),rnd(-2.0,2.0)};
            	  	color <- peopleColors[id];
            	  }
            	 } 
            }
        }
        ask people{
        	if(id =0){
        		target <- one_of(cityMatrix where (each.type = 3)).location + {rnd(-2.0,2.0),rnd(-2.0,2.0)}; 		
        	}
        	if(id =1){
        		target <- one_of(cityMatrix where (each.type = 4)).location + {rnd(-2.0,2.0),rnd(-2.0,2.0)}; 		
        	}
        	if(id =2){
        		target <- one_of(cityMatrix where (each.type = 5)).location + {rnd(-2.0,2.0),rnd(-2.0,2.0)}; 		
        	}
        }
	}  
} 

grid cityMatrix width:16  height:16{
	int type;
	rgb color;
	
   	aspect base{	
   		 draw shape color:color  border:#black;	
    }
}

species people skills:[moving]{
	int id;
	point target;
	rgb color;
	aspect base{
	  draw shape color:color;		
	}
	reflex move{
		do goto target:target;// on:cityMatrix;// on:cityMatrix where (each.type = 6);
	}
}

experiment Display  type: gui {
	output {
		display cityMatrixView   type:opengl{	
			species cityMatrix aspect:base;
			species people aspect:base;			
		}
	}
}
