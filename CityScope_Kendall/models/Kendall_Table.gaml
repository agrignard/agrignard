/**
* Name: Loading of GIS data (buildings and roads)
* Author: Arnaud Grignard
* Description: first part of the tutorial: Road Traffic
* Tags: gis
*/

model tutorial_gis_city_traffic

global {
	file bound_shapefile <- file("../includes/big_bounds.shp");
	file buildings_shapefile <- file("../includes/Buildings.shp");
	file roads_shapefile <- file("../includes/Roads.shp");
	file amenities_shapefile <- file("../includes/amenities_large.shp");
	geometry shape <- envelope(bound_shapefile);
	float step <- 10 #mn;
	int nb_people <- 100;
	int current_hour update: (time / #hour) mod 24;
	int min_work_start <- 6;
	int max_work_start <- 8;
	int min_work_end <- 16; 
	int max_work_end <- 20; 
	float min_speed <- 0.1 #km / #h;
	float max_speed <- 0.5 #km / #h; 
	graph the_graph;
	map<string,rgb> color_map<- ["arts_centre"::rgb(255,255,255), "bar"::rgb(255,0,0), "cafe"::rgb(255,125,0), 
	"cinema"::rgb(255,255,255), "college"::rgb(0,0,225), "fast_food"::rgb(255,100,0), "hospital"::rgb(0,255,0), "library"::rgb(225,225,225), "pharmacy"::rgb(0,225,0), "place_of_workship"::rgb(0,255,255),
	"police"::rgb(125,125,125),"post_office"::rgb(125,125,125), "pub"::rgb(255,100,0), "restaurant"::rgb(225,100,0), "school"::rgb(0,0,255), "theatre"::rgb(225,225,225), "university"::rgb(0,0,200)];
	
	init {
		create building from: buildings_shapefile with: [type::string(read ("TYPE"))]{
			if (location.x < world.shape.width*0.4  and location.y > world.shape.height*0.6){
				type <- "Industrial";
				
			}else{
				type <- "Residential";
				color <- #blue ;
			}
		}
		create road from: roads_shapefile ;
		the_graph <- as_edge_graph(road);
		
		list<building> residential_buildings <- building where (each.type="Residential");
		list<building>  industrial_buildings <- building  where (each.type="Industrial") ;
		create people number: nb_people {
			speed <- min_speed + rnd (max_speed - min_speed) ;
			start_work <- min_work_start + rnd (max_work_start - min_work_start) ;
			end_work <- min_work_end + rnd (max_work_end - min_work_end) ;
			living_place <- one_of(residential_buildings) ;
			working_place <- one_of(industrial_buildings) ;
			objective <- "resting";
			location <- any_location_in (living_place); 
		}
		create amenity from: amenities_shapefile with: [type::string(read ("amenity"))];
		
	}
}

species building schedules: []{
	string type;
	rgb color <- #gray  ;
	
	aspect base {
		draw shape color: #gray depth:100;
	}
}

species road  schedules: []{
	rgb color <- #red ;
	aspect base {
		draw shape color: #white ;
	}
}

species people skills:[moving]{
	rgb color <- #yellow ;
	building living_place <- nil ;
	building working_place <- nil ;
	int start_work ;
	int end_work  ;
	string objective ; 
	point the_target <- nil ;
	
	reflex time_to_work when: current_hour = start_work and objective = "resting"{
		objective <- "working" ;
		the_target <- any_location_in (working_place);
	}
	
	reflex time_to_go_home when: current_hour = end_work and objective = "working"{
		objective <- "resting" ;
		the_target <- any_location_in (living_place); 
	} 
	 
	reflex move when: the_target != nil {
		do goto target: the_target on: the_graph ; 
		if the_target = location {
			the_target <- nil ;
		}
	}
	
	aspect base {
		if(objective = "resting"){
			color <-#red;
		}
		if(objective = "working"){
			color <-#green;
		}
		draw circle(20) color: color;
	}
}

species amenity schedules: []{
	string type;
	aspect base {
		draw circle(20) color: color_map[type];
	}
}

experiment road_traffic type: gui {	
	output {
		display city_display  type:opengl background:#black{
			species building aspect: base;
			species road aspect: base ;
			species people aspect: base ;
			species amenity aspect: base ;
				
		}
	}
}