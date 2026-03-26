extends ProgressBar

signal _on_little_level_up()
signal _on_medium_level_up()

var level: int = 0

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
	level += 1
	if level % 5 == 0 and level <= 25: _on_medium_level_up.emit()
	else: _on_little_level_up.emit()
	max_value = int(max_value * 1.1 + 1)
	value = 0
	
