extends BTAction

func _tick(_delta: float) -> Status:
	var lord: Lord = agent

	var pos_lord: Vector2 = lord.global_position

	if pos_lord.x > 2500:
		lord.global_position.x = 200
		return FAILURE
	
	if pos_lord.x < 50:
		lord.global_position.x = 2400
		return FAILURE
	
	return SUCCESS
