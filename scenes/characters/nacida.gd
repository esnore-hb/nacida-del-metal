## Personaje principal controlable del juego.
## Representa a una Nacida de la Bruma capaz de empujar y tirar metales.
class_name Nacida
extends RigidBody2D

@onready var animation_player = $AnimationPlayer
@onready var footsteps: AudioStreamPlayer = $Footsteps

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

## Componente de salud de la nacida
@onready var health_component: HealthComponent = $HealthComponent

## Sprite principal del personaje.
@onready var sprite_2d: Sprite2D = $Sprite2D

## RayCast utilizado para detectar si el personaje está sobre el suelo.
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Línea visual utilizada al tirar metales.
@onready var enlace_metalico_tirar: Line2D = $EnlaceMetalicoTirar

## Línea visual utilizada al empujar metales.
@onready var enlace_metalico_empujar: Line2D = $EnlaceMetalicoEmpujar

## Cuerpo de colision de la nacida
@onready var hurt_box_enemys: HurtboxComponent = $HurtBoxEnemys

## Bullet es la moneda que tira la nacida
@onready var bullet_spawn_mark: Marker2D = $Pivot/BulletSpawnMark

## Atributo de muerte de la nacida.
@export var is_dead = false

## Cantidad de Monedaas que posee la nacida.
@export var cantidad_monedas: int = 0

## Fuerza horizontal aplicada cada frame de física.
@export var MOVE_SPEED: float = 150.0

## Velocidad horizontal máxima permitida.
@export var MAX_SPEED: float = 200.0

## Fuerza aplicada al saltar.
@export var JUMP_FORCE: float = -500.0

## Limite de metal de Hierro (para tirar)
@export var LIMITE_HIERRO: int = 1000

## Limite de metal de Acero (para empujar)
@export var LIMITE_ACERO: int = 1000

## Escena guardada para las balas(monedas)
@export var bullet_scene = load("res://scenes/metals/metal_liviano.tscn")

@export var sfx: AudioStream

## Cantidad de metal de Hierro (para tirar)
var hierro = LIMITE_HIERRO

## Cantidad de metal de Acero (para empujar)
var acero = LIMITE_ACERO

var taking_damage = false


## Señal emitida al tirar de un metal.
## direction_metal: dirección normalizada hacia el metal.
## pos: posición global de la Nacida.
signal pulling(direction_metal: Vector2, pos: Vector2)

## Señal emitida al empujar un metal.
## direction_metal: dirección normalizada hacia el metal.
## pos: posición global de la Nacida.
signal pushing(direction_metal: Vector2, pos: Vector2)

## Señal recibida de un Metal liviano al ser recogida
signal pickup_coin


## Indica si actualmente se está empujando metal.
var metal_pushing: bool = false

## Posición global actual del mouse.
var mouse_vec: Vector2 = Vector2.ZERO

## Posición global actual de la Nacida.
var pos: Vector2 = Vector2.ZERO

## Dirección desde la Nacida hacia el mouse.
var direction_metal: Vector2 = Vector2.ZERO

var pivot_flipped = false



func _ready() -> void:
	Game.nacida = self

	enlace_metalico_tirar.points = [Vector2.ZERO, Vector2.ZERO]
	enlace_metalico_tirar.hide()

	enlace_metalico_empujar.points = [Vector2.ZERO, Vector2.ZERO]
	enlace_metalico_empujar.hide()
	
	pickup_coin.connect(_increase_coin)
	
	if health_component:
		health_component.died.connect(_on_death)

@onready var pivot: Node2D = $Pivot


func _physics_process(_delta: float) -> void:
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
	
	if Input.is_action_just_pressed("fire"):
		if pos.x < mouse_vec.x and pivot_flipped:
			pivot.apply_scale(Vector2(-1,1))
			pivot_flipped = false
		elif pos.x > mouse_vec.x and not pivot_flipped:
			pivot.apply_scale(Vector2(-1,1))
			pivot_flipped = true
		fire()

	if Input.is_action_pressed("nacida_pull"):
		# Hierro: tirar del metal.
		pulling.emit(direction_metal.normalized(), pos)

		enlace_metalico_tirar.points[1] = direction_metal
		enlace_metalico_tirar.show()
		
		hierro -= 1 if hierro else 0

	elif Input.is_action_pressed("nacida_push"):
		# Acero: empujar metal.
		pushing.emit(direction_metal.normalized(), pos)

		enlace_metalico_empujar.points[1] = direction_metal
		enlace_metalico_empujar.show()
		
		acero -= 1 if acero else 0

	else:
		enlace_metalico_tirar.hide()
		enlace_metalico_empujar.hide()

	_set_animation(direction)

	apply_central_impulse(force)


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	# Evita que el personaje rote por físicas.
	rotation_degrees = 0.0

func _increase_coin() -> void:
	cantidad_monedas += 1
	
func fire() -> void:
	if not cantidad_monedas:
		Debug.log("No tienes monedas para disparar")
		return
	cantidad_monedas -= 1

	if not bullet_scene:
		Debug.log("ERROR: Me olvide poner la bala en el inspector")
		return
		
	var bullet_inst = bullet_scene.instantiate()
	
	get_parent().add_child(bullet_inst)
	
	if not bullet_spawn_mark:
		Debug.log("ERROR: Me olvide poner el BulletSpawnMark en la escena")
		return
		
	bullet_inst.global_position = bullet_spawn_mark.global_position
	AudioManager.play_sfx(sfx)
	
	var mouse_direction = bullet_spawn_mark.global_position.direction_to(get_global_mouse_position())
	bullet_inst.global_rotation = mouse_direction.angle()
	
	# Manejo de la bala encargado por la nacida
	bullet_inst.nacida_instanciated = true
	bullet_inst.metal.gravity_scale = 0
	bullet_inst.metal.angular_velocity += 15
	bullet_inst.metal.apply_impulse(mouse_direction.normalized() * 1000)


## Actualiza la orientación y animación del personaje.
func _set_animation(direction: float) -> void:
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	

	if not _on_floor():
		# Animación de salto / aire.
		# sprite_2d.play("jump")
		if not taking_damage:
			state_machine.travel("idle")
		if taking_damage:
			state_machine.travel("hurt")
		pass

	elif abs(linear_velocity.x) > 0.1:
		# Animación de caminar.
		#animation_player.play("walk")
		state_machine.travel("walk")
		pass

	else:
		# Animación idle.
		# sprite_2d.play("idle")
		state_machine.travel("idle")
		pass


## Retorna true si el personaje está tocando el suelo.
func _on_floor() -> bool:
	if ray_cast_2d.is_colliding():
		return true

	return false
		

func take_damage(amount: int = 1) -> void:
	if is_dead: 
		return
	if health_component:
		taking_damage = true
		state_machine.travel("hurt")
		health_component.take_damage(amount)
		taking_damage = false
		
func _on_death() -> void:
	if is_dead: 
		return 
		
	is_dead = true
	await get_tree().create_timer(0.3).timeout
	LevelManager.game_over()
	queue_free()

func die() -> void:
	state_machine.travel("hurt")
	is_dead = true
	LevelManager.game_over()
