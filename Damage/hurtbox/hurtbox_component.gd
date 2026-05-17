class_name HurtboxComponent
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("¡Choqué con un área llamada: ", area.name, "!") # Si no sale esto, es problema de Layers/Masks
	var hitbox = area as HitboxComponent
	print("¿Es una HitboxComponent válida?: ", hitbox != null) # Si dice falso, es problema del casteo (punto 1) 
	if hitbox: 
		if owner.has_method("take_damage"):
			owner.take_damage()
		else:
			push_error("Error: El dueño (" + str(owner.name) + ") no tiene la función take_damage.")
