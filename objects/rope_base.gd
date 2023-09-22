extends StaticBody2D

const segment_scene = preload('res://objects/rope_segment.tscn')
var segment_count: int = 65
var last_path: NodePath
var last_pos: Vector2
var rope: PhysicsBody2D
var last_segment: PhysicsBody2D
var rope_points: PackedVector2Array = []
var rope_colors: Array = []

func _angle_difference(angle_a: float, angle_b: float) -> float:
	var diff := angle_a - angle_b
	if abs(diff) > TAU / 2.0:
		diff -= TAU * sign(diff)
	return diff

func _bezier_interpolate(line: PackedVector2Array, subdivision: int) -> PackedVector2Array:
	if subdivision < 1: return line
	if line.size() < 3: return line
	var output := PackedVector2Array()
	for i in range(line.size() - 1):
		var a: Vector2
		var b: Vector2
		var c: Vector2
		var actual_subdivisions: int
		a = line[i]
		b = line[i + 1]
		var c_index := i + 2
		if c_index > line.size() - 1:
			var before_a := line[i - 1]
			var angle := _angle_difference((b - a).angle(), (a - before_a).angle())
			c = b + (b - a).rotated(angle)
			actual_subdivisions = (subdivision) / 2 + 1
		else:
			c = line[c_index]
			actual_subdivisions = subdivision
		var true_a = lerp(a, b, 0.5) if i != 0 else a
		var true_c = lerp(b, c, 0.5)
		for o in range(actual_subdivisions):
			var t: float = 1.0 / subdivision * o
			var ab: Vector2 = lerp(true_a, b, t)
			var bc: Vector2 = lerp(b, true_c, t)
			output.append(lerp(ab, bc, t))
	return output

func prevSegment():
	return self

func _draw():
	# Interpolate rope_points to get bezier
	var bezier_points = _bezier_interpolate(rope_points, 10)
	if bezier_points:
		# Set rope colors
		rope_colors.clear()
		var palllette = [Color('c9c0b7'), Color('242220'), Color('c9c0b7')]
		for i in palllette.size():
			rope_colors.append([])
			for j in bezier_points.size():
				rope_colors[i].append(palllette[(i+j)%3])
		
		# Draw rope
		draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[0]), 7, true)
		draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[1]), 4, true)
		draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[2]), 1, true)

func _ready():
	# Instance x amount of interchained rope segments
	last_path = self.get_path()
	last_pos = $Marker2D.position
	for i in segment_count:
		rope = segment_scene.instantiate()
		add_child(rope)
		rope.position = last_pos
		rope.get_child(0).node_a = last_path
		
		last_path = rope.get_path()
		last_pos += rope.get_child(1).position
	last_segment = rope
	
func _process(delta):
	# Get rope segment positions
	rope_points.clear()
	last_segment = rope
	for i in segment_count:
		rope_points.append(last_segment.position)
		last_segment = last_segment.prevSegment()
		# simulating rappelling up
		#if i == 20:
		#	last_segment.mass = 70 + abs(sin( (Time.get_ticks_msec()%2000)*TAU/2000) )*20
		#	print(last_segment.mass)

	# Call _draw()
	queue_redraw()
