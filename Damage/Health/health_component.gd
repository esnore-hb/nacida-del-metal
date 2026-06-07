class_name HealthComponent
extends Node

signal health_changed(current_health: int)
signal died

@export var max_health: int = 3
#Se define en el inspector
@export var health: int = 3

func _ready() -> void:
	health = max_health

# amount será 1 para Nacida, y 10 para los enemigos
func take_damage(amount: int) -> void:
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		died.emit()
