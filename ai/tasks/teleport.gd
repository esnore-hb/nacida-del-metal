extends BTAction

func _tick(_delta: float) -> Status:
	var lord: Lord = agent

	var pos_lord: Vector2 = lord.global_position

	if pos_lord.x > 4500:
		lord.global_position.x = 3700
		return FAILURE
	
	if pos_lord.x < 3600:
		lord.global_position.x = 4400
		return FAILURE
	
	return SUCCESS
