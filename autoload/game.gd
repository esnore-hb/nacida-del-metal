extends Node

signal nacida_set

var nacida: Nacida:
	set(value):
		nacida = value
		nacida_set.emit()
