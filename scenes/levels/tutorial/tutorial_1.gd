extends Node2D

@onready var push_dialogue_area: Area2D = $pushDialogueArea
@onready var pip_dialogue_area: Area2D = $pipDialogueArea
@onready var vial_dialogue_area: Area2D = $vialDialogueArea

func _ready() -> void:
	pip_dialogue_area.body_entered.connect(_on_pip_dialogue)
	push_dialogue_area.body_entered.connect(_on_push_dialogue)
	vial_dialogue_area.body_entered.connect(_on_vial_dialogue)
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)
	Dialogic.start("res://dialogues/timelines/tutorial_01.dtl")

func _on_dialogue_started() -> void:
	process_mode = PROCESS_MODE_DISABLED

func _on_dialogue_ended() -> void:
	process_mode = PROCESS_MODE_INHERIT
	
func _on_pip_dialogue(body: Node) -> void:
	var player: Nacida = body as Nacida
	if player:
		pip_dialogue_area.set_deferred("monitorable", false)
		pip_dialogue_area.set_deferred("monitoring", false)
		Dialogic.start("res://dialogues/timelines/pips.dtl")

func _on_push_dialogue(body: Node) -> void:
	var player: Nacida = body as Nacida
	if player:
		push_dialogue_area.set_deferred("monitorable", false)
		push_dialogue_area.set_deferred("monitoring", false)
		Dialogic.start("res://dialogues/timelines/push.dtl")

func _on_vial_dialogue(body: Node) -> void:
	var player: Nacida = body as Nacida
	if player:
		vial_dialogue_area.set_deferred("monitorable", false)
		vial_dialogue_area.set_deferred("monitoring", false)
		Dialogic.start("res://dialogues/timelines/vial.dtl")
	
