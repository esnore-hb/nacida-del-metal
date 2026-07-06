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


# Funcion fallback que se asegura que la nacida esta en el nivel
func _nacida_generada():
	nacida = Game.nacida


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0.0


func _recive_damage():
	var state_machine = animation_tree.get("parameters/playback")
	var areas = hitbox_lord.get_overlapping_areas()
	
	if areas:
		var area_detectada = areas[0]
		
		if not (area_detectada.get_parent() is Nacida) and area_detectada.name != "HitboxNacida":
			
			hitbox_lord.set_deferred("monitoring", false)
			
			area_detectada.get_parent().get_parent().queue_free()
			
			health -= 1
			print("lord recive damage")
			print("health: ", health)
			
			if health <= 0:
				state_machine.start("death")
				set_process(false) 
				await get_tree().create_timer(0.5).timeout
				LevelManager.win()
				return
			
			# Iniciamos la animación de golpe
			state_machine.start("take_hit")
			
			# NOTA: Ajusta este 0.3 al tiempo real en segundos que dure tu animación de take_hit
			await get_tree().create_timer(0.3).timeout
			
			if health > 0:
				# FORZAMOS el regreso a la animación de reposo o movimiento
				state_machine.travel("idle") 
				# Reactivamos la hitbox para el siguiente golpe
				hitbox_lord.set_deferred("monitoring", true)
