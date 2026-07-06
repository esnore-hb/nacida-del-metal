extends Node2D

@export var area_pcam: PhantomCamera2D


func _ready() -> void:
	if not area_pcam:
		Debug.log("Me olvide de colocar la camara")
		return
	connect("area_entered", _entered_area)
	connect("area_exited", _exited_area)

func _entered_area(area_2d: Area2D) -> void:
	print(area_2d)
	if area_2d.get_parent() is Nacida:
		area_pcam.set_priority(20)

func _exited_area(area_2d: Area2D) -> void:
	if area_2d.get_parent() is Nacida:
		area_pcam.set_priority(0)
