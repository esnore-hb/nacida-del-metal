extends BTAction

func _tick(_delta: float) -> Status:
	var lord: Lord = agent
	
	var pos_nacida: Vector2 = lord.nacida.global_position
	var pos_lord: Vector2 = lord.global_position
	
	var direction: Vector2 = pos_nacida - pos_lord
	
	if direction.length() < 200:
		lord.apply_central_impulse(-direction)
		return FAILURE
	
	return SUCCESS
