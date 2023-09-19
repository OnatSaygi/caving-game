extends StaticBody2D

const ropeSegment = preload('res://objects/rope_segment.tscn')
var count = 55
var lastPath
var lastPos
var rope
var lastSegment
var ropePoints: PackedVector2Array = []

func prevSegment():
	return self

func _draw():
	draw_polyline(ropePoints, Color(1, 1, 1), 5, true)

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
	queue_redraw()
