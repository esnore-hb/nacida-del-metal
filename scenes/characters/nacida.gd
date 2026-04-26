class_name Nacida
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0

signal pulling(direction_metal, pos)
signal pushing(direction_metal, pos)

func _ready():
	Game.nacida = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("nacida_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		Debug.log("salte")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("nacida_left", "nacida_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var mouse_vec: Vector2 = get_global_mouse_position()
	var pos: Vector2 = global_position
	var direction_metal = mouse_vec - pos
	
	if Input.is_action_pressed("nacida_pull"):
		pulling.emit(direction_metal.normalized(), pos)
	elif Input.is_action_pressed("nacida_push"):
		pushing.emit(direction_metal.normalized(), pos)

	move_and_slide()
