extends Control

@export var sfx: AudioStream

func _ready() -> void:
	AudioManager.play_sfx(sfx)
	await get_tree().create_timer(1.0).timeout
	LevelManager.main_menu()
	
