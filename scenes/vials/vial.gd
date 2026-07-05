extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@export var sfx: AudioStream

func _ready() -> void:
	animation_tree.active = true
	var state_machine = animation_tree.get("parameters/playback")
	state_machine.travel("idle")
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player:
		set_deferred("monitoring", false)
		if player.acero <=500:
			player.acero+=500
		else:
			player.acero=1000
		if player.hierro <=500:
			player.hierro+=500
		else:
			player.hierro=1000
		#var state_machine = animation_tree.get("parameters/playback")
		#state_machine.travel("pick_up")
		AudioManager.play_sfx(sfx)
		#await get_tree().create_timer(0.20).timeout
		queue_free()
