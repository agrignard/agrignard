/**
* Name: JSON File Loading
* Author:  Arnaud Grignard
* Description: Initialize a grid from a JSON FIle. 
* Tags:  load_file, grid, json
*/
model json_loading


global
{
	file JsonFile <- json_file("../includes/cityIO.json");
	map<string, unknown> c <- JsonFile.contents;
	map<int, rgb> peopleColors <- [0::# blue, 1::# yellow, 2::# red, 3::# blue, 4::# yellow, 5::# red];
	map<int, rgb> buildingColors <- [0::rgb(189, 183, 107), 1::rgb(189, 183, 107), 2::rgb(189, 183, 107), 3::rgb(230, 230, 230), 4::rgb(230, 230, 230), 5::rgb(230, 230, 230)];
	map<int, geometry> peopleShape <- [0::square(0.5), 1::circle(0.25), 2::triangle(0.5)];
	file andorra_texture <- file('../images/andorrABM.png');
	int nb_pedestrians <- 0 max: 10 min: 0 parameter: "Pedestrians:" category: "Environment";
	int nb_pev <- 5; // max: 10 min: 0 parameter: "PEVs:" category: "Environment";
	int nb_car <- 0 max: 10 min: 0 parameter: "Cars:" category: "Environment";
	int maximumJobCount <- 10;
	file prob <- text_file("../includes/demand.txt");
	list<float> prob_array <- [];
	int max_building_density <- 25;
	int people_per_floor <- 10;
	int total_population <- 0;
	float step <- 1 # second;
	int current_second update: (time / # second) mod 86400;
	list<int> density_array <- c["objects"]["density"];
	float max_prob;
	int job_interval <- 10;
	list<job> queue <- [] update: job where (each.status = "waiting");
	list<map<string, int>> cells <- c["grid"];

	init
	{
		loop mm over: cells
		{
			cityMatrix cell <- cityMatrix grid_at { mm["x"], mm["y"] };
			cell.type <- int(mm["type"]);
			if (int(cell.type) = 6)
			{
			// Road cell.
				cell.color <- rgb(40, 40, 40);
				cell.density <- 0;
				//do initAgent(cell);
			} else
			{
				if (int(cell.type) = -1)
				{
					cell.density <- 0;
					cell.color <- (flip(0.5) ? # green : # gray);
					// Garden or park or other unused non-road space.
				} else
				{
					cell.density <- int(density_array[int(cell.type)] * people_per_floor);
					total_population <- total_population + cell.density;
					cell.color <- buildingColors[int(cell.type)];
				}

			}

		}

		do init_pev_fleet;
		
		loop r from: 0 to: length(prob) - 1
		{
			add (float(prob[r]) * maximumJobCount / 60) to: prob_array;
		}

		max_prob <- max(prob_array);
		
		ask pev {
			do findNewTarget;
		}
	}

	reflex job_create when: every(job_interval # cycle)
	{
		float p <- prob_array[current_second];
		float r <- rnd(0, max_prob);
		if (r <= p)
		{
			int job_count;
			if (floor(r * job_interval) = 0)
			{
				job_count <- flip(r * job_interval) ? 1 : 0;
			} else
			{
				job_count <- int(floor(r * job_interval));
				// write string(job_count) color: #black;
			}
			// TODO - Rounding float to nearest integer.
			if (job_count > 0)
			{
				create job number: job_count
				{
					start <- current_second;
					// TODO: Figure out prob with buildings.
					pickup <- one_of(cityMatrix where (each.density > 0)).location;
					dropoff <- one_of(cityMatrix where (each.density > 0)).location;
					status <- "waiting";
				}
			}

		}

	}

	action init_pev_fleet
	{
		create pev number: nb_pev
		{
			status <- 0;
			shape <- geometry(peopleShape[1]);
			location <- one_of(cityMatrix where (each.type = 6)).location;
			color <- # white;
			speed <- 0.2;
		}
	}

	action initAgent (cityMatrix cell)
	{
		create people number: nb_pedestrians
		{
			id <- int(cell.type);
			shape <- geometry(peopleShape[0]);
			location <- cell.location + { rnd(-2.0, 2.0), rnd(-2.0, 2.0) };
			color <- peopleColors[rnd(2)];
			speed <- 0.1;
		}
		/*
    	  create people number:nb_car{
    	  	id <-int(cell.type);
    	  	shape <- geometry(peopleShape[2]);
    	  	location <- cell.location + {rnd(-2.0,2.0),rnd(-2.0,2.0)};
    	  	color <- peopleColors[rnd(2)];	
    	  	speed <-0.3;
    	  } 
    	  */
	}

	point getRandomBuilding
	{
		int current_density <- 0;
		int r <- rnd(total_population);
		loop mm over: cells {
			cityMatrix cell <- cityMatrix grid_at { mm["x"], mm["y"] };
			if (cell.density > 0) {
				if (current_density >= r)
				{
					return cell.location;
				} else
				{
					current_density <- current_density + cell.density;
				}
			}
		}
	}

}

grid cityMatrix width: 16 height: 16
{
	int type;
	rgb color;
	int density;
	
	aspect base
	{
		draw shape color: color border: # black;
	}

	aspect depth
	{
		draw shape color: color depth: density / max_building_density;
	}

	aspect andorra
	{
		draw shape color: rgb(0, 0, 0, 125) depth: 10 - type;
	}

}

species job
{
	int start;
	point pickup;
	point dropoff;
	string status <- "waiting";
}

species pev skills: [moving] {
	int status <- 0; // 0 = wandering, 1 = inRoute, 2 = delivering.
	job the_job <- nil;
	point target;
	rgb color <- #white;
	
	aspect base
	{
		draw circle(1) at: location color:color;
	}

	reflex move when: target != nil {
		//do goto target: target on: (cityMatrix where (each.type = 6)) speed: speed; //
		path path_followed <- self goto [target::target, on::(cityMatrix where (each.type = 6)), return_path:: true];
		// TODO: Path becomes empty after several iterations.
		write path_followed;
		if (target = location)
		{
			target <- nil;
			do findNewTarget;
		}
	}
	
	action findNewTarget {
		if (status = 0) {
			// Try to pop off queue.
			if (length(queue) > 0 and target = nil) {
				job j <- queue[0];
				//j.status <- "delivering";
				remove j from: queue;
				status <- 1;
				the_job <- j;
				target <- j.pickup;
				color <- # green;
			} else if (target = nil) {
				write "3";
				status <- 0;
				// Still wandering.
				target <- one_of(cityMatrix where (each.type = 6)).location;
				color <- # white;
				the_job <- nil;
			}
		} else if (status = 1) {
			write "4";
			status <- 2;
			target <- the_job.dropoff;
			color <- # red;
		} else if (status = 2) {
			write "5";
			status <- 0;
			// Still wandering.
			target <- one_of(cityMatrix where (each.type = 6)).location;
			color <- # white;
		}
	}

}

species people skills: [moving]
{
	int id;
	point target;
	rgb color;
	
	aspect base
	{
		draw shape at: location color: color;
	}

	action findNewTarget
	{
		if (id = 6)
		{
			target <- one_of(cityMatrix where (each.type = 6)).location; //+ {rnd(-2.0,2.0),rnd(-2.0,2.0)}; 		
		}

	}

	reflex move
	{
		do goto target: target on: cityMatrix where (each.type = 6) speed: speed;
		if (target = location)
		{
			write "target = location " + self;
			do findNewTarget;
		}

	}

}

experiment Display type: gui
{
	output
	{
		display cityMatrixView type: opengl background: # black
		{
			species cityMatrix aspect: depth;
			species people aspect: base;
			species pev aspect: base;
			/*species cityMatrix aspect:base position:{400,30,0.1} size:{0.4,0.4,0.4};
			species people aspect:base position:{400,30,0.1} size:{0.4,0.4,0.4};	
			
			graphics table{
				//CITYMATRIX
				int feetSize <-75;
				draw box(100/16,100/16,feetSize) at:{0,0,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{0,100,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{100,0,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{100,100,-feetSize} color:#white;
				draw square(100) at:{50,50,-feetSize*0.75} color:#gray;
				//ANDORRA
				draw box(100/16,100/16,feetSize) at:{300,0,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{600,100,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{600,0,-feetSize} color:#white;
				draw box(100/16,100/16,feetSize) at:{300,100,-feetSize} color:#white;
				draw rectangle(300,100) texture:andorra_texture.path at:{450,50,0} color:#gray;
				draw rectangle(300,100)  at:{450,50,-feetSize*0.75} color:#gray;
			}*/
		}

	}

}
