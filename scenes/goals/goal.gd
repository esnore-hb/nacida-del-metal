extends Area2D

@onready var sprite_2D_goal: Sprite2D = $Sprite2D

var can_exit: bool = false
var total_pips_in_level: int = 0

func _ready() -> void:
	await get_tree().process_frame
	total_pips_in_level = get_tree().get_nodes_in_group("pips").size()
	body_entered.connect(_on_body_entered)
	Game.pips_changed.connect(_on_global_pips_changed)
	_check_pips_count(Game.pips)

func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player:
		if can_exit:
			LevelManager.next_level()
		else:
			print("Puerta bloqueada. Tienes: ", Game.pips, " / Necesitas: ", total_pips_in_level)

func _on_global_pips_changed(value: int) -> void:
	_check_pips_count(value)

func _check_pips_count(value: int) -> void:
	if value >= total_pips_in_level:
		can_exit = true
		sprite_2D_goal.modulate = Color.WHITE 
	else:
		can_exit = false
		sprite_2D_goal.modulate = Color(1, 1, 1, 0.3)
