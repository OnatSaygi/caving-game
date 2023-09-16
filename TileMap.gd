extends TileMap

const mapSize = Vector2i(100, 300)

func _ready():
	generate(mapSize, 0.13)

func generate(mapSize, treshold):
	clear()
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	
	var cells = []
	for x in mapSize.x:
		for y in mapSize.y:
			var val = noise.get_noise_2d(x*6, y*2)
			if val < treshold:
				cells.append(Vector2i(x, y))
			else:
				set_cell(0, Vector2i(x, y), 0)
	set_cells_terrain_connect(0, cells, 0, 0)
