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
    map<int,geometry> peopleShape <-[0::square(0.5), 1::circle(0.25), 2::triangle(0.5)];
    file andorra_texture <- file('../images/andorrABM.png');
    int nb_pedestrians <- 0 max: 10 min: 0 parameter: "Pedestrians:" category: "Environment";
    int nb_pev <- 20 max: 100 min: 0 parameter: "PEVs:" category: "Environment";
    int nb_car <- 0 max: 10 min: 0 parameter: "Cars:" category: "Environment";
    
    int matrix_size <- 16;
    list< map<string, unknown> > job_queue <- [];
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
	int graph_interval <- 1000;
	int maximumJobCount <- 10;
	
	int max_wait_time <- 15 * 60;
	
	int missed_jobs <- 0;
	int completed_jobs <- 0;
	int total_jobs <- 0;
   
	init { 
		list<map<string, int>> cells <- c["grid"];
		
        loop mm over: cells {                 
            cityMatrix cell <- cityMatrix grid_at {mm["x"],mm["y"]};
            cell.type <-int(mm["type"]);
            if(int(cell.type) = 6){
            	  cell.color <-rgb(40,40,40);
            	  cell.density <- 0;
            	  // do initAgent(cell);       	  
            } else if (int(cell.type) = -1) {
            	  cell.color <- (flip(0.5) ? #green : #gray);
            	  cell.density <- 0;
            } else {
            	  cell.color <- buildingColors[int(cell.type)];
            	  cell.density <- int(density_array[int(cell.type)] * people_per_floor);
				  total_population <- total_population + cell.density;
            }
        }
        
        loop r from: 0 to: length(prob) - 1
		{
			add (float(prob[r]) * maximumJobCount / 60) to: prob_array;
		}
		
		max_prob <- max(prob_array);
        
        loop i from: 0 to: nb_pev - 1 {
        	create pev {
	    	  	pev_id <- i;
	    	  	location <- one_of(cityMatrix where (each.type = 6)).location + {rnd(-2.0,2.0),rnd(-2.0,2.0)};
	    	  	color <- # white;
	    	  	speed <-0.2;
	    	  	status <- "wander";
	    	 }
        }
        
        ask pev {
        	do findNewTarget;
        }
	}
	
	action initAgent (cityMatrix cell){
		 create people number:nb_pedestrians{
            	  	id <-int(cell.type);
            	  	shape <- geometry(peopleShape[0]);
            	  	location <- cell.location + {rnd(-2.0,2.0),rnd(-2.0,2.0)};
            	  	color <- peopleColors[rnd(2)];
            	  	speed <-0.1;	
            	  }
            	  create people number:nb_car{
            	  	id <-int(cell.type);
            	  	shape <- geometry(peopleShape[2]);
            	  	location <- cell.location + {rnd(-2.0,2.0),rnd(-2.0,2.0)};
            	  	color <- peopleColors[rnd(2)];	
            	  	speed <-0.3;
            	  } 
	}
	
	action findLocation(map<string, float> result) {
		int total_density <- 0;
		int random_density <- rnd(0, total_population);
		bool done <- false;
		loop cell over: cityMatrix {
			if (cell.density > 0) {
				// Some sort of building cell.
				total_density <- total_density + cell.density;
				if (total_density >= random_density) {
					// We have found our building.
					bool found <- false;
					int i <- 1;
					list<cityMatrix> neighbors;
					loop while: (found = false) {
						neighbors <- cell.neighbors where (each.type = 6);
						found <- length(neighbors) != 0;
						i <- i + 1;
						if (i > matrix_size) {
							break;
						}
					}
					if (found) {
						point road_cell <- one_of(neighbors).location;
						// Return a map???
						result['x'] <- float(road_cell.x);
						result['y'] <- float(road_cell.y);
						done <- true;
						return;
					} else {
						break;
					}
				}
			}
		}
		if (not done) {
			point road_cell <- one_of(cityMatrix where (each.type = 6)).location;
			result['x'] <- float(road_cell.x);
			result['y'] <- float(road_cell.y);
			return;
		}
	} 
	
	reflex job_manage when: every(job_interval # cycles)
	{
		
		// Manage any missed jobs.
		
		loop job over: job_queue {
			if (current_second - int(job['start']) > max_wait_time) {
				missed_jobs <- missed_jobs + 1;
				total_jobs <- total_jobs + 1;
				remove job from: job_queue;
			}
		}
		
		// Add new jobs.
		
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
			if (job_count > 0)
			{
				loop i from: 0 to: job_count - 1 {
					map<string, unknown> m;
					m['start'] <- current_second;
					m['status'] <- 'waiting';
					map<string, float> pickup;
					do findLocation(pickup);
					m['pickup.x'] <- float(pickup['x']);
					m['pickup.y'] <- float(pickup['y']);
					map<string, float> dropoff;
					do findLocation(dropoff);
					m['dropoff.x'] <- float(dropoff['x']);
					m['dropoff.y'] <- float(dropoff['y']);
					add m to: job_queue;
				}
			} 
		}
		
		// TODO: Create graphical representation of these values.
		
		write string(total_jobs) + ", " + string(completed_jobs) + ", " + string(missed_jobs) color: # black;

	}
} 

grid cityMatrix width:matrix_size  height:matrix_size {
	int type;
	rgb color;
	int density;
	
   	aspect base{	
   		 draw shape color:color border:#black;	
    }
    aspect depth{
	  draw shape color:color depth:density / max_building_density * 2;		
	}
	
	aspect andorra{
	  draw shape color:rgb(0,0,0,125) depth:10-type;		
	}
}

species pev skills: [moving] {
	int pev_id;
	point target;
	rgb color;
	string status;
	map<string, unknown> pev_job;
	
	aspect base {
		draw circle(1.5) at: location color: color;
	}
	
	action findNewTarget {
		if (status = 'wander') {
			if (length(job_queue) > 0) {
				map<string, unknown> job <- job_queue[0];
				remove job from: job_queue;
				pev_job <- job;
				status <- 'pickup';
				float p_x <- float(job['pickup.x']);
				float p_y <- float(job['pickup.y']);
				target <- { p_x, p_y, 0.0};
				color <- # green;
			} else {
				status <- 'wander';
				target <- one_of(cityMatrix where (each.type = 6 and each.location distance_to self >= matrix_size / 2)).location;
				color <- # white;
			}
		} else if (status = 'pickup') {
			status <- 'dropoff';
			float d_x <- float(pev_job['dropoff.x']);
			float d_y <- float(pev_job['dropoff.y']);
			target <- { d_x, d_y, 0.0};
			color <- # blue;
		} else if (status = 'dropoff') {
			completed_jobs <- completed_jobs + 1;
			total_jobs <- total_jobs + 1;
			status <- 'wander';
			target <- one_of(cityMatrix where (each.type = 6 and each.location distance_to self >= matrix_size / 2)).location;
			color <- # white;
		}
	}
	
	reflex move {
		do goto target: target on: cityMatrix where (each.type = 6) speed: speed;
		if (target = location) {
			do findNewTarget;
		} else if (status = 'wander') {
			if (length(job_queue) > 0) {
				map<string, unknown> job <- job_queue[0];
				remove job from: job_queue;
				pev_job <- job;
				status <- 'pickup';
				float p_x <- float(job['pickup.x']);
				float p_y <- float(job['pickup.y']);
				target <- { p_x, p_y, 0.0};
				color <- # green;
			}
		}
	}
}

species people skills:[moving]{
	int id;
	point target;
	rgb color;
	aspect base{
	  draw shape at:location color:color;		
	}
		
	action findNewTarget{
		if(id =6){
        		target <- one_of(cityMatrix where (each.type = 6)).location ;//+ {rnd(-2.0,2.0),rnd(-2.0,2.0)}; 		
        	}

	}
	reflex move{
		do goto target:target on:cityMatrix where (each.type = 6) speed: speed;
		if (target = location){
			write "target = lcoation" + self;
			do findNewTarget;
		}
	}
}

experiment Display  type: gui {
	output {

		display cityMatrixView   type:opengl background:#black {	
			species cityMatrix aspect:depth;
			species people aspect:base;
			species pev aspect:base;
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
		
		display chart refresh: every(graph_interval # cycles) {
			chart "Job Rate" type: series {
				data "Completion Rate" value: completed_jobs / (total_jobs = 0 ? 1 : total_jobs) color: # green;
			}
		}
	}
}
