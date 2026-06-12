class_name UiMetales
extends Control


@onready var hierro_disponible: ProgressBar = $HierroDisponible
@onready var acero_disponible: ProgressBar = $AceroDisponible
var nacida: Nacida


func _ready() -> void:
	if Game.nacida:
		nacida = Game.nacida

		hierro_disponible.max_value = nacida.LIMITE_HIERRO
		hierro_disponible.value = nacida.hierro

		acero_disponible.max_value = nacida.LIMITE_ACERO
		acero_disponible.value = nacida.acero
	else:
		Game.nacida_set.connect(_nacida_generada)


func _nacida_generada() -> void:
	nacida = Game.nacida

	hierro_disponible.max_value = nacida.LIMITE_HIERRO
	hierro_disponible.value = nacida.hierro

	acero_disponible.max_value = nacida.LIMITE_ACERO
	acero_disponible.value = nacida.acero


func _process(_delta: float) -> void:
	if nacida:
		hierro_disponible.value = nacida.hierro
		acero_disponible.value = nacida.acero
