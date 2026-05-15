extends Area2D

@onready var sprite_2D_goal: Sprite2D = $Sprite2D
var can_exit: bool = false

func _ready() -> void:
	#sprite_2D_goal.play("default")
	body_entered.connect(_on_body_entered)
	Game.pips_changed.connect(_on_global_pips_changed)
	_check_pips_count(Game.pips)
	
func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player and can_exit:
		#sprite_2D_goal.play("open_door")
		#await sprite_2D_goal.animation_finished
		LevelManager.next_level()
	elif player and not can_exit:
		print("Falta recolectar algunas pips para avanzar")

func _on_global_pips_changed(value: int) -> void:
	_check_pips_count(value)

func _check_pips_count(value: int) -> void:
	if value <= 0:
		can_exit = true
		# Opcional: Feedback visual de que la meta está activa
		sprite_2D_goal.modulate = Color.WHITE 
	else:
		can_exit = false
		sprite_2D_goal.modulate = Color(1, 1, 1, 0.3) # Semitransparente si falta recolectar
