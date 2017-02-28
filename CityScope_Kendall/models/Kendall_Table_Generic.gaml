/**
* Name: Loading of GIS data (buildings and roads)
* Author: Arnaud Grignard
* Description: first part of the tutorial: Road Traffic
* Tags: gis
*/

model tutorial_gis_city_traffic

global {
	file bound_shapefile <- file("../includes/bounds.shp");
	file buildings_shapefile <- file("../includes/Buildings.shp");
	file roads_shapefile <- file("../includes/Roads.shp");
	file amenities_shapefile <- file("../includes/volpe_amenities.shp");
	file tracts_shapefile <- file("../includes/tracts.shp");
	geometry shape <- envelope(bound_shapefile);
	float step <- 10 #sec;
	int nb_people <- 1000;
	int current_hour update: (time / #hour) mod 24;
	int min_work_start <- 6;
	int max_work_start <- 10;
	int min_lunch_start <- 11;
	int max_lunch_start <- 13;
	int min_rework_start <- 14;
	int max_rework_start <- 16;
	int min_dinner_start <- 18;
	int max_dinner_start <- 20;
	int min_work_end <- 21; 
	int max_work_end <- 23; 
	float min_speed <- 4 #km / #h;
	float max_speed <- 6 #km / #h; 
	graph the_graph;
	
	
	map<string,list> amenities_map_settings<- ["arts_centre"::[rgb(255,255,255),triangle(50)], "bar"::[rgb(255,0,0),square(50)], "cafe"::[rgb(255,125,0),square(50)], "cinema"::[rgb(225,225,225),triangle(50)], 
	"fast_food"::[rgb(255,255,0),square(50)] ,"market_place"::[rgb(0,255,0),square(75)] , "music_club"::[rgb(255,105,180),hexagon(50)], "nightclub"::[rgb(255,182,193),hexagon(50)],
	 "pub"::[rgb(255,99,71),square(50)], "restaurant"::[rgb(255,215,0),square(50)], "theatre"::[rgb(255,255,255),triangle(50)]];
	 
	 
	 map<string,rgb> amenities_map<- ["arts_centre"::rgb(255,255,255), "bar"::rgb(255,0,0), "cafe"::rgb(255,125,0), "cinema"::rgb(225,225,225), 
	"fast_food"::rgb(255,255,0) ,"market_place"::rgb(0,255,0) , "music_club"::rgb(255,105,180), "nightclub"::rgb(255,182,193),
	 "pub"::rgb(255,99,71), "restaurant"::rgb(255,215,0), "theatre"::rgb(255,255,255)];
	 
	list category_color<- [rgb(255,0,0), rgb(255,255,0), rgb(0,0,255)];
	 
	 
	//INTERACTION GRAPH 
	graph my_graph;
	int degreeMax <- 1;
	//Distance to know if a sphere is adjacent or not with an other
	int distance parameter: 'distance ' min: 1 <- 10#m;	
	bool drawInteraction <- false parameter: "Draw Interaction:" category: "Visualization";
	
	init {
		create building from: buildings_shapefile with: [type::string(read ("TYPE"))]{
			if (location.x < world.shape.width*0.4  and location.y > world.shape.height*0.6){
				type <- "Industrial";
				
			}else{
				type <- "Residential";
				color <- #blue ;
			}
			if(shape.area<1000){
				depth<-50.0;
			}
			else{
				depth<-100.0;
			}
		}
		create road from: roads_shapefile ;
		the_graph <- as_edge_graph(road);
		
		list<building> residential_buildings <- building where (each.type="Residential");
		list<building>  industrial_buildings <- building  where (each.type="Industrial") ;
		//FROM FILE
		create amenity from: amenities_shapefile with: [type::string(read ("amenity"))]{
			color <- rgb(amenities_map_settings[type][0]);
			shape <- geometry(amenities_map_settings[type][1]) at_location location;
			category<-rnd(2);	
		}	
		
		create people number: nb_people {
			speed <- min_speed + rnd (max_speed - min_speed) ;
			initialSpeed <-speed;
			start_work <- min_work_start + rnd (max_work_start - min_work_start) ;
			time_to_lunch <- min_lunch_start + rnd (max_lunch_start - min_lunch_start) ;
			time_to_rework <- min_rework_start + rnd (max_rework_start - min_rework_start) ;
			time_to_dinner <- min_dinner_start + rnd (max_dinner_start - min_dinner_start) ;
			end_work <- min_work_end + rnd (max_work_end - min_work_end) ;
			category<-rnd(2);			
			living_place <- one_of(residential_buildings) ;
			working_place <- one_of(industrial_buildings) ;
			eating_place <- one_of(amenity where (each.category=category and (each.type="fast_food" or each.type="restaurant" or each.type="cafe"))) ;
			dining_place <- one_of(amenity where ((each.type="arts_centre" or each.type="theatre" or each.type="bar"))) ;
			objective <- "resting";
			location <- any_location_in (living_place); 
			
		}		
	}
    reflex updateDegreeMax when:(drawInteraction=true){
		do degreeMax_computation;
	}

	action degreeMax_computation {
		my_graph <- people as_distance_graph(distance);
		degreeMax <- 1;
		ask people {
			if ((my_graph) degree_of (self) > degreeMax) {
				degreeMax <- (my_graph) degree_of (self);
			}
		}
	}
}

species building schedules: []{
	string type;
	rgb color <- #gray  ;
	float depth;
	
	aspect base {	
     	draw shape color: rgb(125,125,125,125) depth:depth*shape.area*0.00005;	
	}
}

species road  schedules: []{
	rgb color <- #red ;
	aspect base {
		draw shape color: rgb(125,125,125) ;
	}
}

species people skills:[moving]{
	rgb color <- #yellow ; 
	float initialSpeed;
	building living_place <- nil ;
	building working_place <- nil ;
	amenity eating_place<-nil;
	amenity dining_place<-nil;
	int start_work ;
	int time_to_lunch;
	int time_to_rework;
	int time_to_dinner;
	int end_work;
	string objective ;
	string curMovingMode<-"travelling"
;	int category; 
	point the_target <- nil ;
	int degree;
	float radius;
	
	reflex time_to_work when: current_hour = start_work and objective = "resting"{
		objective <- "working" ;
		curMovingMode <- "travelling";
		the_target <- any_location_in (working_place);
		speed <-initialSpeed;
	}
	
	reflex time_to_go_lunch when: current_hour = time_to_lunch and objective = "working"{
		objective <- "eating" ;
		curMovingMode <- "travelling";
		the_target <- any_location_in (eating_place); 
		speed <-initialSpeed;
	} 
	
	reflex time_to_go_rework when: current_hour = time_to_rework and objective = "eating"{
		objective <- "reworking" ;
		curMovingMode <- "travelling";
		the_target <- any_location_in (working_place);
		speed <-initialSpeed; 
	} 
	reflex time_to_go_dinner when: current_hour = time_to_dinner and objective = "reworking"{
		objective <- "dinning" ;
		curMovingMode <- "travelling";
		the_target <- any_location_in (dining_place);
		speed <-initialSpeed; 
	} 
	
	reflex time_to_go_home when: current_hour = end_work and objective = "dinning"{
		objective <- "resting" ;
		curMovingMode <- "travelling";
		the_target <- any_location_in (living_place);
		speed <-initialSpeed; 
	} 
	 
	reflex move {//when: the_target != nil {
		do goto target: the_target ;//on: the_graph ; 
		if the_target = location {
			the_target <- nil ;
			curMovingMode <- "wandering";
		}
		if(curMovingMode = "wandering"){
			do wander speed:0.5 #km / #h;
		}
	}
	
	reflex compute_degree when:(drawInteraction=true){
		degree <- my_graph = nil ? 0 : (my_graph) degree_of (self);
		radius <- ((((degree + 1) ^ 1.4) / (degreeMax))) * 5;
		color <- hsb(0.66,degree / (degreeMax + 1), 0.5);
	}
	
	aspect base {
		draw circle(5#px) color: color;
	}
	
	aspect dynamic {
		draw circle(10) color: category_color[category];
	}
}

species amenity schedules:[]{
	string type;
	int category;
	rgb color;
	aspect base {
		draw shape color: color;
	}
}

experiment road_traffic type: gui {	
	float minimum_cycle_duration <- 0.05;
	output {
		
		display city_display  type:java2D background:#black{
			species building aspect: base;
			species road aspect: base refresh:false;
			species people aspect: dynamic ;
			species amenity aspect: base ;
			/*graphics "text" 
			{
               draw "CityGamatrix" color: # white font: font("Helvetica", 20, #bold) at: { -1000, 20};
               draw square(100) color:#yellow at: { -600, 200};   draw "$" color: # white font: font("Helvetica", 20, #bold) at: { -500, 250};
               draw square(100) color:#red at: { -600, 400};   draw "$$" color: # white font: font("Helvetica", 20, #bold) at: { -500, 450};
               draw square(100) color:#blue at: { -600, 600};   draw "$$$" color: # white font: font("Helvetica", 20, #bold) at: { -500, 650};
               draw string(current_hour) + "h" color: # white font: font("Helvetica", 30, #italic) at: { -500, 900};
            }*/
           
            	  graphics "edges" {
				//Creation of the edges of adjacence
				if (my_graph != nil  and drawInteraction = true) {
					loop eg over: my_graph.edges {
						geometry edge_geom <- geometry(eg);
						float val <- 255 * edge_geom.perimeter / distance; 
						draw line(edge_geom.points)  color: rgb(val,val,val);
						write "draw lines";
					}
				}	
			}	
		}
	}
}