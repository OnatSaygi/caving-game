class_name RopeSegment2D
extends RigidBody2D

const segment_scene = preload('res://objects/rope_segment.tscn')

var root: Rope2D = null
var prev_segment: RopeSegment2D: set = _set_prev_segment
var next_segment: RopeSegment2D

func _set_prev_segment(segment: RopeSegment2D):
	prev_segment = segment
	
func add_segment_as_sibling() -> RopeSegment2D:
	var sibling: RopeSegment2D
	sibling = segment_scene.instantiate()
	add_sibling(sibling)

	sibling.global_position = $Marker2D.global_position
	sibling.global_rotation = global_rotation
	sibling.prev_segment = self

	next_segment = sibling
	$PinJoint2D.node_a = sibling.get_path()
	
	return sibling
