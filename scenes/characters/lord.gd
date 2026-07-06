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
	animation_tree.active = true
	var state_machine = animation_tree.get("parameters/playback")
	state_machine.travel("idle")
	if Game.nacida:
		nacida = Game.nacida
	else:
		Game.nacida_set.connect(_nacida_generada)


func _process(_delta: float) -> void:
	_recive_damage()
	print(global_position)


# Funcion fallback que se asegura que la nacida esta en el nivel
func _nacida_generada():
	nacida = Game.nacida


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0.0


func _recive_damage():
	var state_machine = animation_tree.get("parameters/playback")
	if hitbox_lord.get_overlapping_areas() and \
		hitbox_lord.get_overlapping_areas()[0].get_parent().get_parent() is MetalLiviano:

		hitbox_lord.get_overlapping_areas()[0].get_parent().get_parent().queue_free()
		if health < 0:
			state_machine.start("death")
			await get_tree().create_timer(0.5).timeout
			LevelManager.win()
			return
		state_machine.travel("hurt")
		health -= 1
		print("lord recive damage")
		print("health: ", health)
