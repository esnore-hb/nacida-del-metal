class_name Lord
extends RigidBody2D

@export var MOVE_SPEED: float = 150.0
@export var MAX_SPEED: float = 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox_lord: Area2D = $HitboxLord
# CAMBIO: Asegúrate de que el nombre coincida con tu nodo de sprite (ej: $Sprite2D o $AnimatedSprite2D)
@onready var sprite: Sprite2D = $Sprite2D 

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
	_flip_towards_player() # CAMBIO: Llamamos a la función de volteo


# Funcion fallback que se asegura que la nacida esta en el nivel
func _nacida_generada():
	nacida = Game.nacida


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0.0


func _flip_towards_player() -> void:
	if nacida and sprite:
		var direction: float = nacida.global_position.x - global_position.x
		
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false


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
			
			state_machine.start("take_hit")
			
			await get_tree().create_timer(0.3).timeout
			
			if health > 0:
				state_machine.travel("idle") 
				hitbox_lord.set_deferred("monitoring", true)
