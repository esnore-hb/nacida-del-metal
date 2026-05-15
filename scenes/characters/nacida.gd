class_name Nacida
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var MOVE_SPEED = 50
@export var MAX_SPEED = 50
@export var JUMP_FORCE = -500

signal pulling(direction_metal, pos)
signal pushing(direction_metal, pos)

var metal_pushing = false
var mouse_vec: Vector2
var pos: Vector2
var direction_metal: Vector2

func _ready():
	Game.nacida = self


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("nacida_left", "nacida_right")
	var force = Vector2.ZERO
	
	if direction:
		force.x = MOVE_SPEED * direction
		if abs(linear_velocity.x) > MAX_SPEED:
			linear_velocity.x = MAX_SPEED * direction

	if _on_floor() and  Input.is_action_just_pressed("nacida_jump"):
		force.y = JUMP_FORCE

	mouse_vec = get_global_mouse_position()
	pos = global_position
	direction_metal = mouse_vec - pos
	
	if Input.is_action_pressed("nacida_pull"):
		# azul hierro tira
		pulling.emit(direction_metal.normalized(), pos)
		
	elif Input.is_action_pressed("nacida_push"):
		pushing.emit(direction_metal.normalized(), pos)

	_set_animation(direction)
	apply_central_impulse(force)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0


func _set_animation(direction):
	if direction > 0: sprite_2d.flip_h = false
	elif direction < 0: sprite_2d.flip_h = true
	
	if not _on_floor():
		# animacion de estar en el aire
		# sprite_2d.play("jump")
		pass
	elif abs(linear_velocity.x) > 0.1:
		# para la animacion de caminar
		# sprite_2d.play("run")
		pass
	else:
		# para la animacion de estar quieto
		# sprite_2d.play("idle")
		pass


func _on_floor():
	if ray_cast_2d.is_colliding():
		return true
