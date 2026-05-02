extends Control

@onready var resume: Button = %Resume
@onready var retry: Button = %Retry
@onready var main_menu: Button = %MainMenu

func _ready() -> void:
	hide()
	resume.pressed.connect(_on_resume_pressed)
	retry.pressed.connect(_on_retry_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_resume_pressed() -> void:
	Debug.log("resume pressed")
	
func _on_retry_pressed() -> void:
	Debug.log("retry pressed")

func _on_main_menu_pressed() -> void:
	Debug.log("main_manu pressed")
