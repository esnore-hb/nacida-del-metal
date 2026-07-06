class_name Lord
extends RigidBody2D

@export var MOVE_SPEED: float = 150.0
@export var MAX_SPEED: float = 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox_lord: Area2D = $HitboxLord

var nacida: Nacida
var health: int = 3

func _ready() -> void:
	if Game.nacida:
		nacida = Game.nacida
	else:
		Game.nacida_set.connect(_nacida_generada)


func _process(_delta: float) -> void:
	_recive_damage()


# Funcion fallback que se asegura que la nacida esta en el nivel
func _nacida_generada():
	nacida = Game.nacida


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0.0


func _recive_damage():
	if hitbox_lord.get_overlapping_areas():
		hitbox_lord.get_overlapping_areas()[0].get_parent().get_parent().queue_free()
		if health < 0:
			LevelManager.win()
			return
		health -= 1
		print("lord recive damage")
		print("health: ", health)
