extends HitboxComponent

@export var speed: int = 300

func _physics_process(delta: float) -> void:
	var direction = global_transform.x
	global_position += direction * speed * delta
