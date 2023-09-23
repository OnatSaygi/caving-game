class_name Rope2D
extends StaticBody2D

const segment_scene = preload('res://objects/rope_segment.tscn')

var segment_count: int = 25
var first_segment: RopeSegment2D
var last_segment: RopeSegment2D

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
			@warning_ignore("integer_division")
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

func _get_rope_points() -> PackedVector2Array:
	var rope_points = PackedVector2Array()
	var segment = first_segment
	
	if not segment:
		return []
	
	for i in segment_count-1:
		rope_points.append(segment.position)
		segment = segment.next_segment
	
	return rope_points
	
func _draw():
	# Smooth rope_points with bezier 
	var bezier_points = _bezier_interpolate(_get_rope_points(), 10)
	if not bezier_points:
		return
	
	# Set colors to black & white striped
	var rope_colors = Array()
	var palllette = [Color('c9c0b7'), Color('242220'), Color('c9c0b7')]
	for i in palllette.size():
		rope_colors.append([])
		for j in bezier_points.size():
			rope_colors[i].append(palllette[(i+j)%3])
	
	# Draw rope
	draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[0]), 7.0/2, true)
	draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[1]), 4.0/2, true)
	draw_polyline_colors(bezier_points, PackedColorArray(rope_colors[2]), 1.0/2, true)

func _ready():
	# Set first segment
	first_segment = segment_scene.instantiate()
	first_segment.root = self
	first_segment.position = $Marker2D.position
	first_segment.rotation = rotation
	add_child(first_segment)
	$Marker2D/PinJoint2D.node_b = first_segment.get_path()
	
	# Extend the remaining segments
	last_segment = first_segment
	for i in segment_count-2:
		last_segment = last_segment.add_segment_as_sibling()

func extend_rope():
	segment_count += 1
	last_segment = last_segment.add_segment_as_sibling()
	
func _process(delta):
	delta = delta
	
	
	if Input.is_action_just_pressed("ui_accept"):
		extend_rope()
	queue_redraw()
