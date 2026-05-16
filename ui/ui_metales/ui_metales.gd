class_name UiMetales
extends Control

@onready var nacida = Game.nacida
@onready var hierro_disponible: ProgressBar = $VBoxContainer/HierroDisponible
@onready var acero_disponible: ProgressBar = $VBoxContainer/AceroDisponible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hierro_disponible.max_value = nacida.LIMITE_HIERRO
	hierro_disponible.value = nacida.hierro

	acero_disponible.max_value = nacida.LIMITE_ACERO
	acero_disponible.value = nacida.acero


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hierro_disponible.value = nacida.hierro
	acero_disponible.value = nacida.acero
