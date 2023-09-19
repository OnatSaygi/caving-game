extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -900.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 0

const bombScn = preload("res://objects/bomb.tscn")
var explosives = 6
var directionPast = 0

func _process(delta):
	if Input.is_action_just_pressed("bomb"):
		print('boom')
		var bomb = bombScn.instantiate()
		bomb.position = position
		bomb.direction = Vector2(directionPast, -1)
		get_parent().add_child(bomb)
	
	$Sprite2D.flip_h = directionPast != 1

func _physics_process(delta):
	# Add the gravity.
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
