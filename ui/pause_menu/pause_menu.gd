extends Control

@onready var resume: Button = %Resume
@onready var retry: Button = %Retry
@onready var main_menu: Button = %MainMenu
#@onready var quit: Button = %Quit

func _ready() -> void:
	hide()
	resume.pressed.connect(_on_resume_pressed)
	retry.pressed.connect(_on_retry_pressed)
	#quit.pressed.connect(_on_quit_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	LevelManager.main_menu()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	
func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
