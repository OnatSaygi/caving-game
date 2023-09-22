extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -900.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rope_on: PhysicsBody2D
var rope_weight: RigidBody2D
var on_rope: bool = false
var rope_joint: Joint2D

const bombScn = preload("res://objects/bomb.tscn")
var directionPast = 0

func _process(delta):
	if Input.is_action_just_pressed("bomb"):
		print('boom')
		var bomb = bombScn.instantiate()
		bomb.position = position
		bomb.direction = Vector2(directionPast, -1)
		get_parent().add_child(bomb)
	
	$AnimatedSprite2D.flip_h = directionPast != 1

func _physics_process(delta):
	# Add the gravity.
	if not on_rope:
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") :#and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			directionPast = direction
			$AnimatedSprite2D.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.play("stop")
	
	if on_rope:
		global_position = rope_weight.global_position
		if Input.is_action_just_pressed('ui_up'):
			$AnimatedSprite2D.play("jumar")
			var prev_segment = get_node(rope_joint.node_b).prevSegment()
			rope_weight.global_position = prev_segment.global_position
			rope_joint.node_b = prev_segment.get_path()
		elif Input.is_action_just_pressed("ui_down"):
			on_rope = false
			velocity = Vector2(0, 0)
			rope_weight.queue_free()
	else:
		move_and_slide()


func _on_area_2d_body_entered(body):
	if body is RigidBody2D and not on_rope and Input.is_action_pressed('ui_up'):
		print(body.name)
		on_rope = true
		rope_weight = RigidBody2D.new()
		add_sibling(rope_weight)
		rope_weight.collision_layer = 0
		rope_weight.collision_mask = 0
		rope_weight.mass = 50
		rope_weight.global_position = body.global_position
		
		rope_joint = PinJoint2D.new()
		rope_joint.node_a = rope_weight.get_path()
		rope_joint.node_b = body.get_path()
		rope_weight.add_child(rope_joint)
		
	#print(body)
	#print(typeof(body))
	#if body is RigidBody2D and not on_rope and Input.is_action_pressed('ui_up'):
	#	global_position = body.global_position
	#	$PinJoint2D.node_b = body.get_path()
	#	rope_on = body
	#	on_rope = true
		#gravity = 0
		#velocity = position - body.position
		#move_and_slide()
	#	velocity = Vector2(0, 0)
