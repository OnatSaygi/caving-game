extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -900.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var directionPast = 0

const dead_weight_scene = preload("res://objects/dead_weight.tscn")
var dead_weight: DeadWeight2D
var on_rope: RopeSegment2D
var rope_progress = 0
const ROPE_SPEED = 100
const ROPE_LENGTH = 50.0

const bombScn = preload("res://objects/bomb.tscn")

@warning_ignore("unused_parameter")
func _process(delta):
	$AnimatedSprite2D.flip_h = directionPast != 1

	if Input.is_action_just_pressed("bomb"):
		print('boom')
		var bomb = bombScn.instantiate()
		bomb.position = position
		bomb.direction = Vector2(directionPast, -1)
		add_sibling(bomb)

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
		if not on_rope.prev_segment:
			pass
		if rope_progress > ROPE_LENGTH:
			rope_progress = 0
			on_rope = on_rope.prev_segment
			rope_attach_deadweight(on_rope)
			
		var next = on_rope.prev_segment
		var next_pos = next.global_position
		global_position = lerp(dead_weight.global_position, next_pos, rope_progress/ROPE_LENGTH)
		
		if Input.is_action_pressed('ui_left'):
			$AnimatedSprite2D.play("jumar")
			rope_progress += ROPE_SPEED * delta
		elif Input.is_action_just_pressed("ui_down"):
			on_rope = null
			velocity = Vector2(0, 0)
			dead_weight.queue_free()
			dead_weight = null
	else:
		move_and_slide()

func _on_area_2d_body_entered(body):
	if body is RopeSegment2D and not on_rope and Input.is_action_pressed('ui_up'):
		on_rope = body
		rope_attach_deadweight(body)

func rope_attach_deadweight(rope: RopeSegment2D):
	if dead_weight:
		dead_weight.queue_free()
		dead_weight = null
	dead_weight = dead_weight_scene.instantiate()
	add_sibling(dead_weight)
	dead_weight.attach(rope)
