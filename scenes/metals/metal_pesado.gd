extends Node2D

@onready var anclaje: Area2D = $Metal/Anclaje
@onready var metal: StaticBody2D = $Metal

var pulling_active: bool = false
var pushing_active: bool = false
var is_mouse = false
var direc_nacida
var posit_nacida

@export var PULLING_FORCE = 1500
@export var PUSHING_FORCE = 1000


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anclaje.mouse_entered.connect(_on_mouse_enter)
	anclaje.mouse_exited.connect(_on_mouse_exit)

	# Aegurarse que la nacida esta en el nivel
	if Game.nacida:
		print("nacida generada")
		Game.nacida.pulling.connect(_pull_metal)
		Game.nacida.pushing.connect(_push_metal)
	else:
		print("nacida no generada")
		Game.nacida_set.connect(_nacida_generada)


func _nacida_generada():
	print("fall_back")
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
	pulling_active = Input.is_action_pressed("nacida_pull") and is_mouse and Game.nacida.hierro > 0
	pushing_active = Input.is_action_pressed("nacida_push") and is_mouse and Game.nacida.acero > 0

	if pulling_active:
		Game.nacida.gravity_scale = 0
		Game.nacida.apply_impulse(direc_nacida * PULLING_FORCE * delta)
	elif pushing_active:
		Game.nacida.gravity_scale = 0
		Game.nacida.apply_impulse(-direc_nacida * PUSHING_FORCE * delta)
	else:
		Game.nacida.gravity_scale = 1
