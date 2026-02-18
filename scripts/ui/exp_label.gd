extends Label

var level: int = 0

func _level_up() -> void:
	level += 1
	text = "Level: " + str(level)
