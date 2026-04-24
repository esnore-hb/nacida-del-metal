extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 900.0
const REBOTE = -250.0
var muerto = false

var rezando = true

func _ready():
	$AnimatedSprite2D.play("Pray")
	await get_tree().create_timer(2.5).timeout
	rezando = false

func _physics_process(delta: float) -> void:
	# Animaciones
	if rezando:
		return
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")

	# Flip según dirección
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if muerto:
		return
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$SonidoSalto.play()
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto = colision.get_collider()
		if objeto != null and objeto.is_in_group("enemigos"):
			var normal = colision.get_normal()
			if normal.y < -0.5:
				objeto.destruir()
				velocity.y = REBOTE
			else:
				morir()
	if position.y > 1000:
		morir()
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().get_nodes_in_group("pause_menu").is_empty():
			var canvas = CanvasLayer.new()
			canvas.layer = 100
			get_tree().root.add_child(canvas)
			var pausa = preload("res://escenas/pause_menu.tscn").instantiate()
			canvas.add_child(pausa)

func morir():
	if muerto:
		return
	muerto = true
	get_tree().change_scene_to_file("res://escenas/game_over.tscn")
