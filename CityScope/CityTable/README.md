# Tiles

Tiles is a small Processing sketch to generate a grid of texturized tiles from an external file.

This is a very preliminary first step of what is expected to be an ABM simulator over a changing grid of tiles, similar to first versions of SimCity. Inspiration comes from [Ira Winder](https://github.com/irawinder)'s work in Legotizer and CityScope. 

## Usage

Create a tsv file containing tiles' type, code and texture:

	TYPE	TL	TR	BL	BR	TEXTURE
	Land	2	0	0	1	land.png
	Street	2	0	1	0	street.png
	...
	Park	2	1	1	1	park.png

and an input tsv file containing tiles' id, code and rotation (in the future this will be automatically generated/modified by another script):

	ID	TL	TR	BL	BR	ROT
	1	2	1	0	1	0
	2	2	0	0	1	90
	...
	n	2	0	1	0	180
	
Create a Tiles grid assigning its size, and load types data:

	Tiles tableau = new Tiles(5,5);
	tableau.types("tiles.tsv");
	
Load input data whenever needed/desired (p.e. periodically or after a specific key press)

	tableau.update("input.tsv");

Draw Tiles grid

	tableau.draw();


## Contributors

This project will grow with [Arnaud Grignard](https://github.com/agrignard)'s help.

## License

Tiles is released under the [MIT License](http://www.opensource.org/licenses/MIT).
