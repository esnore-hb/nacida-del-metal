## Personaje principal controlable del juego.
## Representa a una Nacida de la Bruma capaz de empujar y tirar metales.
class_name Nacida
extends RigidBody2D

## Sprite principal del personaje.
@onready var sprite_2d: Sprite2D = $Sprite2D

## RayCast utilizado para detectar si el personaje está sobre el suelo.
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Línea visual utilizada al tirar metales.
@onready var enlace_metalico_tirar: Line2D = $EnlaceMetalicoTirar

## Línea visual utilizada al empujar metales.
@onready var enlace_metalico_empujar: Line2D = $EnlaceMetalicoEmpujar


## Fuerza horizontal aplicada cada frame de física.
@export var MOVE_SPEED: float = 50.0

## Velocidad horizontal máxima permitida.
@export var MAX_SPEED: float = 50.0

## Fuerza aplicada al saltar.
@export var JUMP_FORCE: float = -500.0


## Señal emitida al tirar de un metal.
## direction_metal: dirección normalizada hacia el metal.
## pos: posición global de la Nacida.
signal pulling(direction_metal: Vector2, pos: Vector2)

## Señal emitida al empujar un metal.
## direction_metal: dirección normalizada hacia el metal.
## pos: posición global de la Nacida.
signal pushing(direction_metal: Vector2, pos: Vector2)


## Indica si actualmente se está empujando metal.
var metal_pushing: bool = false

## Posición global actual del mouse.
var mouse_vec: Vector2 = Vector2.ZERO

## Posición global actual de la Nacida.
var pos: Vector2 = Vector2.ZERO

## Dirección desde la Nacida hacia el mouse.
var direction_metal: Vector2 = Vector2.ZERO


func _ready() -> void:
	Game.nacida = self

	enlace_metalico_tirar.points = [Vector2.ZERO, Vector2.ZERO]
	enlace_metalico_tirar.hide()

	enlace_metalico_empujar.points = [Vector2.ZERO, Vector2.ZERO]
	enlace_metalico_empujar.hide()


func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("nacida_left", "nacida_right")
	var force: Vector2 = Vector2.ZERO

	if direction:
		force.x = MOVE_SPEED * direction

		if abs(linear_velocity.x) > MAX_SPEED:
			linear_velocity.x = MAX_SPEED * direction

	if _on_floor() and Input.is_action_just_pressed("nacida_jump"):
		force.y = JUMP_FORCE

	mouse_vec = get_global_mouse_position()
	pos = global_position
	direction_metal = mouse_vec - pos

	if Input.is_action_pressed("nacida_pull"):
		# Hierro: tirar del metal.
		pulling.emit(direction_metal.normalized(), pos)

		enlace_metalico_tirar.points[1] = direction_metal
		enlace_metalico_tirar.show()

	elif Input.is_action_pressed("nacida_push"):
		# Acero: empujar metal.
		pushing.emit(direction_metal.normalized(), pos)

		enlace_metalico_empujar.points[1] = direction_metal
		enlace_metalico_empujar.show()

	else:
		enlace_metalico_tirar.hide()
		enlace_metalico_empujar.hide()

	_set_animation(direction)

	apply_central_impulse(force)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Evita que el personaje rote por físicas.
	rotation_degrees = 0.0


## Actualiza la orientación y animación del personaje.
func _set_animation(direction: float) -> void:
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true

	if not _on_floor():
		# Animación de salto / aire.
		# sprite_2d.play("jump")
		pass

	elif abs(linear_velocity.x) > 0.1:
		# Animación de caminar.
		# sprite_2d.play("run")
		pass

	else:
		# Animación idle.
		# sprite_2d.play("idle")
		pass


## Retorna true si el personaje está tocando el suelo.
func _on_floor() -> bool:
	if ray_cast_2d.is_colliding():
		return true

	return false
