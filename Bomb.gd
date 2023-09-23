extends RigidBody2D

signal boom

var direction = Vector2(0, 0)
const SPEED = 200

func _ready():
	print(direction)
	set_axis_velocity(direction*SPEED)

func explode():
	emit_signal('boom')
	var collidingBodies = get_colliding_bodies()
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
				i.set_cells_terrain_connect(0, holes, 0, -1)

func _process(delta):
	pass

func _physics_process(delta):
	var collidingBodies = get_colliding_bodies()
	if collidingBodies:
		$AnimationPlayer.play("new_animation")
