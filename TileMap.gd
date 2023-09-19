extends TileMap

const mapSize = Vector2i(100, 100)
#const mapSize = Vector2i(30, 30)
const layerGround = 0
const layerBg = 1
const tilesetGround = 0
const treshold = 0.13

var noise

func _ready():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	#noise.seed = 2
	generate(mapSize, treshold)

func noise_2d_custom(x, y, val):
	return noise.get_noise_2d(x*10, y*4) > val

func generate(mapSize, treshold):
	clear()
	
	# Inside
	var cells = []
	for x in mapSize.x:
		for y in mapSize.y:
			if noise_2d_custom(x, y, treshold):
				cells.append(Vector2i(x, y))
	
	# Borders
	for x in mapSize.x:
		cells.append(Vector2i(x, 0))
		cells.append(Vector2i(x, -1))
		cells.append(Vector2i(x, mapSize.y-1))
	for y in mapSize.y:
		cells.append(Vector2i(0, y))
		cells.append(Vector2i(mapSize.x-1, y))

	set_cells_terrain_connect(layerGround, cells, 0, 0)
	
	# Entry hole
	var holes = []
	var entrances = [] # (size, pos.x)
	var prev = false
	for x in mapSize.x:
		var curr = not noise_2d_custom(x, 0, treshold)
		if curr:
			if prev:
				entrances[-1] += Vector2i(1, 0)
			else:
				entrances.append(Vector2i(1, x))
		prev = curr
	entrances.sort()
	var caveEntrance = entrances[entrances.size()/2]
	#var caveEntrance = entrances[1]
	print(entrances)
	print(caveEntrance)
	for x in caveEntrance.x:
		#self.erase_cell(layerGround, Vector2i(x + caveEntrance.y, 0))
		holes.append(Vector2i(x + caveEntrance.y, 0))
		holes.append(Vector2i(x + caveEntrance.y, -1))
	set_cells_terrain_connect(layerGround, holes, 0, -1)
	
	# background
	noise.seed = randi()
	cells = []
	for x in mapSize.x:
		for y in mapSize.y:
			if noise_2d_custom(x*2, y*2, treshold/2):
				cells.append(Vector2i(x, y))
	set_cells_terrain_connect(layerBg, cells, 0, 1)

func _process(delta):
	clear_layer(2)
	
