/**
* Name: GamaMatrix
* Author:  Arnaud Grignard
* Description: This is a template for the CityMatrix importation in GAMA. The user has the choice to instantiate the grid either from a local file ( onlineGrid = false) or from the cityscope server ( onlineGrid = true)
* The grid is by default loaded only once but it can be loaded every "refresh" cycle by setting (dynamicGrid= true).
* Tags:  grid, load_file, json
* Residential (0:L, 1:M, 2: S) 
* Office: (L:3, M:4, S: 5) - Road: 6 - Parking/Green Area : -1
*/

model GamaMatrix   

global {
    map<string, unknown> matrixData;
    map<int,rgb> buildingColors <-[0::rgb(189,183,107), 1::rgb(189,183,107), 2::rgb(189,183,107),3::rgb(230,230,230), 4::rgb(230,230,230), 5::rgb(230,230,230),6::rgb(40,40,40)];
    list<map<string, int>> cells;
	//list<float> density_array;
	bool onlineGrid <-false parameter: "Online Grid:" category: "Environment";
	bool dynamicGrid <-false parameter: "Update Grid:" category: "Environment";
	int refresh <- 100 min: 1 max:1000 parameter: "Refresh rate (cycle):" category: "Environment";
	
	init { 	
        do initGrid;
	} 
	
	action initGrid{
		if(onlineGrid = true){
		  matrixData <- json_file("http://cityscope.media.mit.edu/citymatrix_ml.json").contents;
	    }
	    else{
	      matrixData <- json_file("../includes/cityIO_Kendall.json").contents;
	    }	
		cells <- matrixData["grid"];
		//density_array <- matrixData["objects"]["density"];
		loop c over: cells {                 
            cityMatrix cell <- cityMatrix grid_at {13-c["x"]+16,(c["y"])+13};
            cell.type <-int(c["type"]);
            if(cell.type = -1){
            	  cell.color <- #gray;
            }
            if(cell.type = -2){
            	  cell.color <- #black;
            }
            if(cell.type != -2 and cell.type != -1){
            	  cell.color <-buildingColors[cell.type];
            }
             cell.visible <-true;
            //cell.density <- (cell.type = -1 or cell.type= 6) ? 0.0 : density_array[cell.type];
        }
	}
	
	reflex updateGrid when: ((cycle mod refresh) = 0) and (dynamicGrid = true){	
		do initGrid;
	}
} 

grid cityMatrix width:44  height:44 {
	int type;
	rgb color<-#white;
	//float density;
	bool visible <-true;
	
	aspect flat{
		if(visible){
		  draw shape color:color border:#black;		
		} 	
	}
	
}

experiment GridDisplay  type: gui {
	output {
		display cityMatrixView   type:opengl background:#white {	
			species cityMatrix aspect:flat;
		}
	}
}


