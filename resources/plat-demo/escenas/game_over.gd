extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://escenas/nivel.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://escenas/main_menu.tscn")

func _on_exit_pressed():
	get_tree().quit()
