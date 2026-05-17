extends Control

func _ready() -> void:
	# Espera 3 segundos y luego reinicia el nivel donde murió
	await get_tree().create_timer(1.0).timeout
	LevelManager.restart_level()
