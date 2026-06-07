extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
#@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("pips")
	animation_tree.active = true
	var state_machine = animation_tree.get("parameters/playback")
	state_machine.travel("idle")
	#Game.pips += 1
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player:
		set_deferred("monitoring", false)
		#pick_up_sound.play()
		Game.pips += 1
		var state_machine = animation_tree.get("parameters/playback")
		state_machine.travel("pick_up")
		await get_tree().create_timer(0.20).timeout
		queue_free()
