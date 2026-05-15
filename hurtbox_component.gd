class_name HurtboxComponent
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as HitboxComponent
	if hitbox: 
		if owner.has_method("take_damage"):
			owner.take_damage()
		else:
			push_error("Error: El dueño (" + str(owner.name) + ") no tiene la función take_damage.")
