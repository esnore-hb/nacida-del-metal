extends CharacterBody2D

var velocidad = 50.0
var direccion = 1
const GRAVITY = 900.0
var distancia_recorrida = 0.0
const DISTANCIA_MAX = 150.0
var vivo = true

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if not vivo:
		return
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.x = velocidad * direccion
	move_and_slide()
	
	distancia_recorrida += velocidad * delta
	if distancia_recorrida >= DISTANCIA_MAX:
		distancia_recorrida = 0.0
		direccion *= -1
	
	$AnimatedSprite2D.flip_h = direccion >  0
	$AnimatedSprite2D.play("walk")

func destruir():
	vivo = false
	remove_from_group("enemigos")
	velocity.x = 0
	$AnimatedSprite2D.play("death")
	$SonidoSquish.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://escenas/victory.tscn")
