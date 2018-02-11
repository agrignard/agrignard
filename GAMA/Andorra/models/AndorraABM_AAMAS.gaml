/**
* Name: AndorraABM
* Author: jzou70
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model AndorraABM

global
{
	//------ GIS File(s) ---------//
	file shape_file_road <- file("../includes/Road/countryRoad.shp");
	file shape_file_table_bound <- file("../includes/bounds/AndorraTableBound.shp");	
	//------ JSON File --------//
	file rnc_fillfile <- json_file("../includes/rncResultsCleanFill.json");
	file rnc_speedfile <- json_file('../includes/rncResultsCleanSpeed.json');
	map<string, unknown> rncfillData <- rnc_fillfile.contents;
	map<string, unknown> rncspeedData <- rnc_speedfile.contents;
	//------ Global Variables --------//
	geometry shape <- envelope(shape_file_table_bound);
	int current_hour update: (time / #hour) mod 24;
	graph road_graph;
	bool fill <- true; //iteration 1

	init
	{
		create road from: shape_file_road;
		road_graph <- as_edge_graph(road);
		list<map<string, unknown>> RNCpeople <- rncspeedData["data"];
		if fill {
			RNCpeople <- rncfillData["data"];
		}
		loop p over: RNCpeople
		{	
			create people 
			{   
				if fill{
					loop i from: 0 to: length(trajectory)-1 {
						trajectory[i] <- (string(p["long"][i]) != "na") ? point(to_GAMA_CRS({ float(p["long"][i]), float(p["lat"][i]) }, "WGS_1984")) : {1,1};
					}
					location <- trajectory[0];
					target <- trajectory[1];
					current <- 2;
				} 
				else {
					loop i from: 0 to: length(trajectory)-1 {
						trajectory[i] <- point(to_GAMA_CRS({ float(p["long"][i]), float(p["lat"][i]) }, "WGS_1984"));
						speeds[i] <- float(p["speed"][i]);
					}
					location <- trajectory[0];
					target <- trajectory[1];
					speed <- speeds[1];
					current <- 2;
				}	
			}
		}
	}
}

species people skills:[moving]
{
	point target;
	list<point> trajectory <- list_with(24,{0,0});
	list<float> speeds <- list_with(24,0.0);
	int current;
	bool done <- false;
	
	reflex move when: target != nil
	{
		do goto target: target on: road_graph;
		if target = location {
			if current = length(trajectory) {
				target <- nil;
				done <- true;
			}
			else {
				target <- trajectory[current];
				if !fill {
					speed <- speeds[current];
				}
				current <- current + 1; 
			}
		}
	}
	//------------- ASPECT--------------------------//
	aspect base
	{   
		draw circle(10#px) color: #blue;	
		if done {
			draw circle(10#px) color: #red;
		}
	}
}

species road
{
	aspect base
	{
		draw shape color: #white;
	}
}

experiment Display type: gui
{
	output
	{
		display myView type: opengl background: #black
		{   
			species road aspect: base;
			species people aspect:base;
		}
	}
}
