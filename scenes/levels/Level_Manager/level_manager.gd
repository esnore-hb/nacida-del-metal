extends Node

@export var main_menu_scene: PackedScene
@export var credits_scene: PackedScene
@export var you_died_scene: PackedScene
@export var levels: Array[PackedScene]
@export var tutorial: PackedScene

var current_level: int = 0

func start() -> void:
	current_level = 0
	Game.pips = 0
	if not levels.is_empty():
		get_tree().change_scene_to_packed(levels[0])

func next_level() -> void:
	current_level+=1
	Game.pips = 0
	if current_level < levels.size():
		get_tree().change_scene_to_packed.call_deferred(levels[current_level])
	else:
		credits()

func main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func tutorial_level() -> void:
	get_tree().change_scene_to_packed(tutorial)


func credits() -> void:
	get_tree().change_scene_to_packed.call_deferred(credits_scene)

func game_over() -> void:
	# Llama a esto cuando Nacida muera
	if you_died_scene:
		get_tree().change_scene_to_packed.call_deferred(you_died_scene)

func restart_level() -> void:
	Game.pips = 0
	if current_level < levels.size():
		get_tree().change_scene_to_packed.call_deferred(levels[current_level])
