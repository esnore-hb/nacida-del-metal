extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var pick_up_sound: AudioStreamPlayer = $PickUp

func _ready() -> void:
	#animated_sprite_2d.play("coin_roll")
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	var player: Nacida = body as Nacida
	if player:
		set_deferred("monitoring", false)
		#pick_up_sound.play()
		#Game.coins += 1
		#animated_sprite_2d.play("pick_up")
		#await animated_sprite_2d.animation_finished
		queue_free()
