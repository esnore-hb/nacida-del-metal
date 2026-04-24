class_name Nacida
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	var mouse_vec: Vector2 = get_global_mouse_position()
	var pos: Vector2 = global_position
	var direction_metal = mouse_vec - pos
	
	# Mouse in viewport coordinates.
	if Input.is_action_pressed("nacida_pull"):
		velocity = direction_metal.normalized() * 500
		print("MBL Click/Unclick at: ", velocity)
	elif Input.is_action_pressed("nacida_push"):
		velocity = direction_metal.normalized() * -500
		print("MBR Click/Unclick at: ", velocity)

	move_and_slide()
