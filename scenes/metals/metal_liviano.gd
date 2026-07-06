class_name MetalLiviano
extends Node2D

@onready var anclaje: Area2D = $Metal/Anclaje
@onready var metal: RigidBody2D = $Metal

var pulling_active: bool = false
var pushing_active: bool = false
var is_mouse = false
var direc_nacida
var posit_nacida
var nacida_instanciated: bool = false

signal pickup_coin

@export var PULLING_FORCE = 500
@export var PUSHING_FORCE = 500
@export var PUSHING_REACTION_FORCE = 50


func _ready() -> void:
	anclaje.mouse_entered.connect(_on_mouse_enter)
	anclaje.mouse_exited.connect(_on_mouse_exit)

	# Aegurarse que la nacida esta en el nivel
	if Game.nacida:
		Game.nacida.pulling.connect(_pull_metal)
		Game.nacida.pushing.connect(_push_metal)
	else:
		Game.nacida_set.connect(_nacida_generada)

# Funcion fallback que se asegura que la nacida esta en el nivel
func _nacida_generada():
	Game.nacida.pulling.connect(_pull_metal)
	Game.nacida.pushing.connect(_push_metal)


func _pull_metal(direction_nacida: Vector2, pos_nacida: Vector2) -> void:
	direc_nacida = direction_nacida
	posit_nacida = pos_nacida


func _push_metal(direction_nacida: Vector2, pos_nacida: Vector2) -> void:
	direc_nacida = direction_nacida
	posit_nacida = pos_nacida


func _on_mouse_enter() -> void:
	is_mouse = true


func _on_mouse_exit() -> void:
	is_mouse = false


func _physics_process(delta: float) -> void:
	pulling_active = Input.is_action_pressed("nacida_pull") and is_mouse
	pushing_active = Input.is_action_pressed("nacida_push") and is_mouse

	# Si fue disparado por la nacida
	if nacida_instanciated and not pulling_active and not pushing_active:
		if metal.get_contact_count():
			nacida_instanciated = false

	# Ahora se puede manipular en el juego
	else:
		nacida_instanciated = false
		if pulling_active:
			metal.gravity_scale = 0
			metal.apply_impulse(-direc_nacida * PULLING_FORCE * delta)
		elif pushing_active:
			metal.gravity_scale = 0
			metal.apply_impulse(direc_nacida * PUSHING_FORCE * delta)
			if abs(metal.angular_velocity) < 0.01:
				Game.nacida.gravity_scale = 0
				Game.nacida.apply_impulse(-direc_nacida * PUSHING_REACTION_FORCE * delta)
		else:
			Game.nacida.gravity_scale = 1
			metal.gravity_scale = 1

		# Si la nacida recoge la moneda
		if anclaje and anclaje.overlaps_area(Game.nacida.hurt_box_enemys):
			Game.nacida._increase_coin()
			pickup_coin.emit()
			queue_free()
