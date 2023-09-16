extends Node2D

var markedPos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var playerPos = $player.global_position
	#var tilePos = $TileMap.local_to_map(playerPos)
	#var posDelta = Vector2i(1, 0);
	#$TileMap.erase_cell(0, tilePos+posDelta)
	
	#for i in range(-1, 2):
	#	for j in range(-1, 2):
	#		var posDelta = Vector2i(i, j);
	#		$TileMap.erase_cell(0, tilePos+posDelta)
