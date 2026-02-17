class_name PoisonEffect extends StatusEffectRes

@export var damage_per_tick: float

#func _init(_duration: float = 3.0, _damage_per_tick: float = 5.0, _tick_interval: float = 1.0) -> void:
	#duration = _duration
	#if not damage_per_tick:
		#damage_per_tick = _damage_per_tick
	#tick_interval = _tick_interval
	#stack_mode = StackMode.STACK

func on_tick(actor: Node2D, delta: float, instance: EffectInstance) -> void:
	instance.tick_timer -= delta
	
	if instance.tick_timer <= 0:
		apply_damage(actor)
		instance.tick_timer = tick_interval

func apply_damage(actor: Node2D) -> void:
	if actor.has_method("take_damage"):
		actor.take_damage.rpc(damage_per_tick, false)
