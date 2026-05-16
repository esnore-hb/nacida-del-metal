extends Node

signal nacida_set
signal pips_changed(value: int)

var nacida: Nacida:
	set(value):
		nacida = value
		nacida_set.emit()

var pips: int = 0:
	set(value):
		pips = value
		pips_changed.emit(pips)
