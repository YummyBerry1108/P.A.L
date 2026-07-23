class_name SlowEffect extends StatusEffectRes

@export var speed_multiplier: float

#func _init(_duration: float = 3.0, _speed_multiplier: float = 0.5) -> void:
	#duration = _duration
	#if not speed_multiplier:
		#speed_multiplier = _speed_multiplier

func on_apply(actor: Node2D) -> void:
	if actor.has_method("update_speed"):
		actor.update_speed()

func removed(actor: Node2D) -> void:
	if actor.has_method("update_speed"):
		actor.update_speed()
