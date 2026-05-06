extends Node2D

@onready var anclaje: Area2D = $Metal/Anclaje
@onready var metal: RigidBody2D = $Metal

var is_pulling: bool = false
var is_pushing: bool = false
var is_mouse = false
var direc_nacida
var posit_nacida


# Called when the node enters the scene tree for the first time.
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
	is_pulling = true
	direc_nacida = direction_nacida
	posit_nacida = pos_nacida


func _push_metal(direction_nacida: Vector2, pos_nacida: Vector2) -> void:
	is_pushing = true
	direc_nacida = direction_nacida
	posit_nacida = pos_nacida


func _on_mouse_enter() -> void:
	is_mouse = true


func _on_mouse_exit() -> void:
	is_mouse = false


func _process(delta: float) -> void:
	if is_pulling and is_mouse:
		metal.gravity_scale = 0
		metal.apply_impulse(-direc_nacida * 500 * delta)
		
	elif is_pushing and is_mouse:
		metal.gravity_scale = 0
		metal.apply_impulse( direc_nacida * 500 * delta)
		if abs(metal.angular_velocity) < 0.01:
			Game.nacida.gravity_scale = 0
			Game.nacida.apply_impulse(-direc_nacida * 40)
	else:
		Game.nacida.gravity_scale = 1
		metal.gravity_scale = 1
		is_pulling = false
		is_pushing = false
