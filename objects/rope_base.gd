extends StaticBody2D

const ropeSegment = preload('res://objects/rope_segment.tscn')
var count = 55
var lastPath
var lastPos
var rope 
var lastSegment
var ropePoints: PackedVector2Array = []
var ropeColors: PackedColorArray = []
var bezier: Curve2D = Curve2D.new()

func prevSegment():
	return self

func _draw():
	#draw_polyline(ropePoints, Color.AQUA, 5, true)
	if bezier.point_count > 3:
		var points = bezier.tessellate()
		if points:
			draw_polyline(points, Color.GAINSBORO, 5, true)
		#draw_polyline_colors(ropePoints, ropeColors, 5, true)
	pass

func _ready():
	lastPath = self.get_path()
	lastPos = $Marker2D.position
	pass
	for i in count:
		rope = ropeSegment.instantiate()
		add_child(rope)
		rope.position = lastPos
		rope.get_child(0).node_a = lastPath
		
		lastPath = rope.get_path()
		lastPos += rope.get_child(1).position
	lastSegment = rope
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ropePoints.clear()
	lastSegment = rope
	for i in count:
		ropePoints.append(lastSegment.position)
		lastSegment = lastSegment.prevSegment()
		
	ropeColors.clear()
	for i in ropePoints.size():
		var strain = fmod(float(i)/ropePoints.size(), 1)
		ropeColors.append(Color(1, strain, strain))
	
	bezier.clear_points()
	#for j in range(ropePoints.size()-3, 0, -1)
	for j in ropePoints.size()-2:
		#var d = Vector2(0, 10)
		#var i = ropePoints.size()-j-3
		var d_in = ropePoints[j+0] - ropePoints[j+1]
		var d_out = ropePoints[j+2] - ropePoints[j+1]
		bezier.add_point(ropePoints[j+0], d_in, d_out, 0)
		#bezier.add_point(ropePoints[j+0], ropePoints[j+1], ropePoints[j+2], 0)
		#bezier.add_point(ropePoints[i+0], ropePoints[i+1], ropePoints[i+2])
	bezier.tessellate()
	queue_redraw()
