extends Control

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var tutorial: Button = %Tutorial
@onready var quit: Button = %Quit
@export var sfx_start: AudioStream
@export var sfx_credits: AudioStream
@export var sfx_quit: AudioStream


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	tutorial.pressed.connect(_on_tutorial_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _on_start_pressed() -> void:
	AudioManager.play_sfx(sfx_start)
	LevelManager.start()
	
func _on_tutorial_pressed() -> void:
	AudioManager.play_sfx(sfx_start)
	LevelManager.tutorial_level()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(sfx_quit)
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_credits_pressed() -> void:
	AudioManager.play_sfx(sfx_credits)
	LevelManager.credits()
