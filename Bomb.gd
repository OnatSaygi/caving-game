extends RigidBody2D

var direction = Vector2(0, 0)
const SPEED = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	print(direction)
	set_axis_velocity(direction*SPEED)
	pass # Replace with function body.

func explode():
	var collidingBodies = get_colliding_bodies()
	if collidingBodies:
		for i in collidingBodies:
			print(i.name)
			if i.name != 'TileMap':
				continue
			var pos = i.local_to_map(position)
			print(pos, 'pos')
			var holes = []
			for k in range(-1, 2):
				for j in range(-1, 2):
					var posDelta = Vector2i(k, j)
					holes.append(pos+posDelta)
					#i.erase_cell(0, pos+posDelta)
					i.set_cells_terrain_connect(i.layerGround, holes, 0, -1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var collidingBodies = get_colliding_bodies()
	if collidingBodies:
		$AnimationPlayer.play("new_animation")
