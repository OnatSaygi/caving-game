class_name DeadWeight2D
extends RigidBody2D

var attached_to: RopeSegment2D

func attach(body: RopeSegment2D):
	global_position = body.global_position
	$PinJoint2D.node_b = body.get_path()
	attached_to = body
