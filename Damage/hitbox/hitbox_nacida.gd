class_name HitboxNacida
extends Area2D

# Se puede cambiar el daño en el inspector
@export var damage: int = 10
@export var speed: int = 600

func _physics_process(delta: float) -> void:
	var direction = global_transform.x
	global_position += direction * speed * delta
