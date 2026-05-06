extends Area2D

@onready var sprite_2D_goal: Sprite2D = $Sprite2D

func _ready() -> void:
	#sprite_2D_goal.play("default")
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player:
		#sprite_2D_goal.play("open_door")
		#await sprite_2D_goal.animation_finished
		LevelManager.next_level()
