/**
* Name: Loading of GIS data (buildings and roads)
* Author: Arnaud Grignard
* Description: first part of the tutorial: Road Traffic
* Tags: gis
*/

model tutorial_gis_city_traffic

global {
	file bound_shapefile <- file("../includes/Bounds.shp");
	file buildings_shapefile <- file("../includes/Buildings.shp");
	file roads_shapefile <- file("../includes/Roads.shp");
	geometry shape <- envelope(bound_shapefile);
	
	init {
		create building from: buildings_shapefile ;
		create road from: roads_shapefile ;
	}
}

species building {
	string type; 
	rgb color <- #gray  ;
	
	aspect base {
		draw shape color: #black ;
	}
}

species road  {
	rgb color <- #red ;
	aspect base {
		draw shape color: #black ;
	}
}

experiment road_traffic type: gui {	
	output {
		display city_display  type:opengl{
			species building aspect: base ;
			species road aspect: base ;		
		}
	}
}