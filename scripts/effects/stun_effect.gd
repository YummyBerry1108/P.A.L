class_name StunEffect extends StatusEffectRes

func _init(_duration: float = 3.0) -> void:
	duration = _duration

func on_apply(actor: Node2D) -> void:
	if "stun" in actor:
		actor.stun = true

func removed(actor: Node2D) -> void:
	if "stun" in actor:
		actor.stun = false
