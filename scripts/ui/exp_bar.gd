extends ProgressBar

signal _on_little_level_up()

func add_experience(exp_value: int) -> void:
	if not multiplayer.is_server():
		return

	while exp_value > 0:
		if value + exp_value > max_value:
			exp_value = value + exp_value - max_value
			value = max_value
		else:
			value += exp_value
			exp_value = 0
		
		if value == max_value:
			_level_up()

func _level_up() -> void:
	_on_little_level_up.emit()
	max_value = int(max_value * 1.1)
	value = 0
	
