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

# Si se genero despues de que se generara la moneda, nos conectamos
# a ella
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_pulling and is_mouse:
		metal.apply_impulse(-direc_nacida * 500 * delta)
		metal.gravity_scale = 0
		Debug.log("tirando")
	elif is_pushing and is_mouse:
		metal.apply_impulse( direc_nacida * 500 * delta)
		metal.gravity_scale = 0
		Debug.log("empujando")
	else:
		metal.gravity_scale = 1
		is_pulling = false
		is_pushing = false
