extends Node2D

var markedPos = []

func _ready():
	$RopeBase.last_segment.global_position = $Wall.global_position
	$PinJoint2D.global_position = $Wall.global_position
	$PinJoint2D.node_b = $RopeBase.last_segment.get_path()
