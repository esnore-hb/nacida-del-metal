extends CanvasLayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Escuchamos cuando Nacida aparece en el nivel
	Game.nacida_set.connect(_on_nacida_set)
	
	# Si Nacida ya había cargado antes que el HUD, nos conectamos de inmediato
	if Game.nacida != null:
		_on_nacida_set()

func _on_nacida_set() -> void:
	# Nos aseguramos de que Nacida tiene su componente de vida
	if Game.nacida.health_component:
		# Conectamos la señal del componente DIRECTAMENTE al HUD
		Game.nacida.health_component.health_changed.connect(_on_health_changed)
		
		# Reiniciamos la interfaz a 3 corazones al empezar el nivel
		anim_player.play("reset")

func _on_health_changed(current_health: int) -> void:
	# Reproducimos la animación según la vida que le quede a Nacida
	if current_health == 2:
		anim_player.play("lost_heart_3")
	elif current_health == 1:
		anim_player.play("lost_heart_2")
	elif current_health <= 0:
		anim_player.play("lost_heart_1")
