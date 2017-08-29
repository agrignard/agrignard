/**
* Name: AndorrABM
* Author: Arnaud Grignard
* Description: 
* Tags: Tag1, Tag2, TagN
*/
model AndorrABM

global
{   //--------------------------- GIS FILE --------------------------------------------------//
	file shape_file_road <- file("../includes/Road/countryRoad.shp");
	file shape_file_building <- file("../includes/buildings/buildings.shp");
	file shape_file_zone <- file("../includes/Landuse/landuse.shp");
	file shape_file_table_bound <- file("../includes/bounds/AndorraTableBound.shp");	
	//--------------------------- JSON FILE --------------------------------------------------//
	file rnc_file <- json_file("../includes/rncResults2016_07_18.json");
	map<string, unknown> rncData <- rnc_file.contents;
	//--------------------------- Global Variabe --------------------------------------------------//
	geometry shape <- envelope(shape_file_table_bound) *0.6;
	//geometry shape <- envelope(shape_file_road);
	map<string,rgb> color_map<- ["Andorra"::rgb(220,210,0), "Spain"::#E67E22, "France"::#0061FF, 
	"Belgium"::#553982, "United Kingdom"::#F1C40F, "Russian Federation"::#1ABC9C, "Portugal"::#E74C3C,"Netherlands"::#2ECC71, 
	"Germany"::#C0392B, "Greece"::#EFEFEF, "Hongkong China"::#D14841, "Hungary"::#F7DA64,"Indonesia"::#F7DA64,"Ireland"::#FBA026, "Italy"::#41A85F,"Jamaica"::#FAC51C, "Japan"::#E25041,
	"Kazakhstan"::#C0392B, "Kenya"::#EFEFEF, "Korea S Republic of"::#D14841, "Latvia"::#F7DA64,"Lebanon"::#F7DA64,"Lithuania"::#FBA026, "Luxembourg"::#41A85F,"Malta"::#FAC51C, "Mexico"::#E25041,"Martinique (French Department of)"::#E25041, "Moldova"::#E25041,"Morocco"::#E25041, "Norway"::#E25041,
	"Algeria"::#A38F84,"Argentina Republic"::#54ACD2, "Australia"::#3D8EB9, "Austria"::#EB6B56, "Belarus"::#9365B8, "Brazil"::#00FF00, "Bulgaria"::#75706B,"Canada"::#E25041,"Chile"::#EE0000, "China"::#F7DA64, "South Africa"::#61BD6D, "Slovenia"::#475577,"Slovakia"::#475577,"Singapore"::#F7DA64,"Serbia"::#475577,"Saudi Arabia"::#FFF8DC,"Russian Federation"::#54ACD2,"Romania"::#F7DA64,"Reunion"::#0061FF,"Poland"::#E25041,"Philippines"::#B8312F,
	"Peru"::#E25041,"Palestinian Territory"::#D1D5D8, "Sweden"::#F7DA64, "Switzerland"::#EFEFEF,"Tunisia"::#EB6B56, "Turkey"::#E25041, "Ukraine"::#2C82C9, "United Arab Emirates"::#FFF8DC,"United States"::#2969B0, "Uruguay"::#EFEFEF, "Venezuela"::#D1D5D8];
    map<string,rgb> color_street_map<- ["background"::#black,"building"::rgb(40,40,40),"road"::rgb(75,75,75),"table"::rgb(150,150,150)];
    bool saveScreenshot <-false;
    bool countryLevel;
    
    

	init
	{   
		create road from: shape_file_road;
		create table from: shape_file_table_bound;
		create building from: shape_file_building;

		list<map<string, unknown>> RNCpeople <- rncData["data"];
		loop p over: RNCpeople
		{	
			create people 
			{   
				location <- point(to_GAMA_CRS({ float(p["long"][0]), float(p["lat"][0]) }, "WGS_1984"));
				loop i from: 0 to: length(trajectory) -1 {
				  trajectory[i] <- (string(p["long"][i]) != "na") ? point(to_GAMA_CRS({ float(p["long"][i]), float(p["lat"][i]) }, "WGS_1984")) : {1, 1};
		        }
		        //Build a clean trajectory where ever "na" is removed
		        //cleanTrajectory <-trajectory; 
		        //cleanTrajectory >>- {1, 1};
				nation <- p["nation"];
				color <- color_map[string(p["nation"])];
			}		
		}
		write "init1: nb people :" + length(people);
		ask people{
			if (nation = "Andorra"){
				do die;	
			}
		}
        write "init2: nb people :" + length(people);
	 }
	 
	 reflex globalReflex{
	 	//write ("cycle:" + cycle + "mod" +cycle mod 24);
	 }
	 
	 user_command removeTrajectory{
		ask people{
			drawTrajectory <-false;
			visible <-true;
		}
	}
}

species people
{
	rgb color;
	string nation;
	list<point> trajectory <- list_with(24, {0,0});
	list<point> cleanTrajectory;
	bool drawTrajectory;
	bool visible<-true;
	bool noData <- true;
	bool initPos <-false;
	bool inTheTable <- false;
	
	//------------- REFLEX--------------------------//
	/*reflex updatePosition
	{ if(length(trajectory) = 1){
		location <- trajectory[0];
	  }else{
	    location <- trajectory[cycle mod (length(trajectory)-1)];	
	  }	
	}*/
	
	reflex updateCoolPosition
	
	{   
		if(cycle mod 24 = 0){
		 initPos <- false;	
	    }
	  	if(trajectory[cycle mod 24] != {1,1}){
	  		noData<-false;
	  		location <- trajectory[cycle mod 24];
	  		initPos <- true;
	  	}
	  	else{
	  		noData<-true;
	  		if(initPos = false){
	  	      location <- trajectory[cycle mod 24];
	  	      initPos <- true;
	  		}else{
	  			location <- trajectory[cycle mod 24];
	  		}
	  	}	
	}
	
	
	//------------- SHOW TRAJECTORY ACTION --------------------------//
	user_command "Show trajectory" action:showTrajectory;
	action showTrajectory{
		ask people{
			drawTrajectory <-false;
			visible <-false;
		}
		drawTrajectory <- true;
		visible <-true;
	}	
		
    //------------- ASPECT--------------------------//
	aspect base
	{   
		if(visible){
			draw circle(4#px) color: color;
			if (drawTrajectory){
				draw line(trajectory) color:color;
				loop i from: 0 to: length(trajectory) -1 {
					draw (string(i)) at:trajectory[i] size:2#px color:self.color;
				}
			}	
	    }
	}

	aspect gray{
		draw circle(6#px) color:rgb(125,125,125,40);
	}
}

species road
{
	aspect base
	{
		draw shape color: color_street_map["road"];
	}
}

species building
{   string type <-"none";
	int depth <- rnd(100);
	aspect base
	{
		draw shape color: color_street_map["building"];
	}
	
	aspect box{
		draw shape color: color_street_map["building"] depth:depth;
	}
}

species table{
	aspect base
	{
		draw shape color: color_street_map["table"] empty:true;
	}
}

experiment Display type: gui
{   //parameter "Country Level:" var: countryLevel <- true category: "Grid";
	output
	{   
	    display myView type: opengl autosave:saveScreenshot background:color_street_map["background"] keystone:true
		//display myView type: opengl use_shader:true keystone:[{0.167,0.946},{0.028,0.009}, {0.968,0.011},{0.822,0.977}] camera_pos:{972.89,618.71,2981.76}
		//camera_look_pos:{975.09,623.43,-0.16} camera_up_vector:{0.42,-0.91,0.0 }autosave:saveScreenshot background:color_street_map["background"]
		{   
			graphics world{
				//draw rectangle(world.shape.width,world.shape.height) color:#white;
				draw geometry(shape_file_table_bound) at: geometry(shape_file_table_bound).location color:#white;
			}
			species table aspect:base refresh:false;
			species building aspect: base refresh:false;
			species road aspect: base refresh:false;
			species people aspect:base;
			
		}
		/*display CountryLevel type: opengl autosave:saveScreenshot background:color_street_map["background"]
		camera_pos:{4200,-578,19796} camera_look_pos:{4200,-612,2.31} camera_up_vector:{0,1,0.0 }autosave:saveScreenshot background:color_street_map["background"]
		{   
			graphics world{
				//draw rectangle(world.shape.width,world.shape.height) color:#white;
				//draw geometry(shape_file_table_bound) at: geometry(shape_file_table_bound).location color:#white;
			}
			species table aspect:base refresh:false;
			species building aspect: base refresh:false;
			species road aspect: base refresh:false;
			species people aspect:base;
			
		}*/
	}
}






