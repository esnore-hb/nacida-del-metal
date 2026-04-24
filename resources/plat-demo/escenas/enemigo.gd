extends CharacterBody2D

var velocidad = 50.0
var direccion = 1
const GRAVITY = 900.0
var distancia_recorrida = 0.0
const DISTANCIA_MAX = 100.0
var vivo = true

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
	
	$AnimatedSprite2D.flip_h = direccion > 0
	$AnimatedSprite2D.play("move")

func destruir():
	vivo = false
	remove_from_group("enemigos")
	$CollisionShape2D.set_deferred("disabled", true)
	velocity.x = 0
	$AnimatedSprite2D.play("death")
	$SonidoStomp.play()
	$SonidoSquish.play()
	await get_tree().create_timer(0.8).timeout
	queue_free()
