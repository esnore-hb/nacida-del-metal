extends Node2D

@onready var anclaje: Area2D = $Anclaje
@onready var metal: RigidBody2D = $Metal

signal pulling(direction, nacida_pos)
signal pushing(direction, nacida_pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pulling.connect(_pull_metal)
	pushing.connect(_push_metal)

func _pull_metal(direction: Vector2, pos: Vector2) -> void:
	if (Input.is_action_pressed("nacida_pull") and anclaje.mouse_entered):
		metal.apply_impulse(direction * 500)
		print("me estan tirando")

func _push_metal(direction: Vector2, pos: Vector2) -> void:
	if (Input.is_action_pressed("nacida_push") and anclaje.mouse_entered):
		metal.apply_impulse(direction * -500)
		print("me estan empujando")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (anclaje.mouse_entered):
		print("entro")
	elif (anclaje.mouse_exited):
		print("salio")
