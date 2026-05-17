extends Node

@export var main_menu_scene: PackedScene
@export var credits_scene: PackedScene
@export var you_died_scene: PackedScene
@export var levels: Array[PackedScene]

var current_level: int = 0

func start() -> void:
	current_level = 0
	if not levels.is_empty():
		get_tree().change_scene_to_packed(levels[0])

func next_level() -> void:
	current_level+=1
	if current_level < levels.size():
		get_tree().change_scene_to_packed(levels[current_level])
	else:
		credits()

func main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func credits() -> void:
	get_tree().change_scene_to_packed(credits_scene)

func game_over() -> void:
	# Llama a esto cuando Nacida muera
	if you_died_scene:
		get_tree().change_scene_to_packed(you_died_scene)

func restart_level() -> void:
	# Recarga el nivel actual dejándolo exactamente como estaba al inicio
	# y asegúrate de usar la escena desde el arreglo por si la escena actual era la de Game Over
	if current_level < levels.size():
		get_tree().change_scene_to_packed(levels[current_level])
