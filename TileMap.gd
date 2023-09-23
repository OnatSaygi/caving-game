extends TileMap

const mapSize = Vector2i(50, 50)
const layer_treshold = [0.13, 0.00, -0.10, -0.40]
const noise_x_scale = 10
const noise_y_scale = 4
const noise_z_scale = 1
const noise_z_offset = 9
@export var layer_gradient : Gradient
var noise

const TERRAIN_SET := 0
const TERRAIN := [0, 1, 1, 1]

func _ready():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	clear()
	generate(mapSize)

	for layer in get_layers_count():
		var sample_point = layer/float(get_layers_count())
		var color = layer_gradient.sample(sample_point)
		set_layer_modulate(layer, color)

func noise_3d_custom(x, y, z, val):
	return noise.get_noise_3d(x*noise_x_scale, y*noise_y_scale, z*noise_z_scale) > val

func generate(mapSize):
	
	for layer in 2:
		var cells = []
		
		# Inside
		for x in mapSize.x:
			for y in mapSize.y:
				if noise_3d_custom(x, y, 0, layer_treshold[layer]):
					cells.append(Vector2i(x, y))
		
		# Borders
		for x in mapSize.x:
			cells.append(Vector2i(x, 0))
			cells.append(Vector2i(x, -1))
			cells.append(Vector2i(x, mapSize.y-1))
		for y in mapSize.y:
			cells.append(Vector2i(0, y))
			cells.append(Vector2i(mapSize.x-1, y))

		set_cells_terrain_connect(layer, cells, TERRAIN_SET, TERRAIN[layer])
	
	# Entry hole
	#var holes = []
	#var entrances = [] # (size, pos.x)
	#var prev = false
	#for x in mapSize.x:
	#	get_cell_tile_data(layer: int, coords: Vector2i, use_proxies: bool = false)
	#	var curr = not noise_3d_custom(x, 0, 0, layer_treshold[layer])
	#	if curr:
	#		if prev:
	#			entrances[-1] += Vector2i(1, 0)
	#		else:
	#			entrances.append(Vector2i(1, x))
	#	prev = curr
	#entrances.sort()
	#var caveEntrance = entrances[entrances.size()/2]
	#var caveEntrance = entrances[1]
	#print(entrances)
	#print(caveEntrance)
	#for x in caveEntrance.x:
	#	#self.erase_cell(layerGround, Vector2i(x + caveEntrance.y, 0))
	#	holes.append(Vector2i(x + caveEntrance.y, 0))
	#	holes.append(Vector2i(x + caveEntrance.y, -1))
	#set_cells_terrain_connect(layerGround, holes, 0, -1)
	
	# Decoration
	for layer in range(2, 4):
		print('start', Time.get_ticks_msec())
		var cells = []
		for x in mapSize.x:
			for y in mapSize.y:
				if noise_3d_custom(x, y, noise_z_offset, layer_treshold[layer]):
					cells.append(Vector2i(x, y))
		print('3d noise', Time.get_ticks_msec())
		set_cells_terrain_connect(layer, cells, 0, 1)
		print('terrain connect', Time.get_ticks_msec())

func _process(delta):
	pass
