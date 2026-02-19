class_name PoisonEffect extends StatusEffectRes

@export var damage_per_tick: float = 5.0

func _on_tick(actor: Node2D, delta: float, instance: EffectInstance) -> void:
	if instance.ticks_left > 0:
		instance.tick_timer -= delta
		
		if instance.tick_timer <= 0:
			apply_damage(actor)
			instance.ticks_left -= 1
			instance.tick_timer += tick_interval

func apply_damage(actor: Node2D) -> void:
	if actor.has_node("DamageComponent"):
		actor.get_node("DamageComponent").take_damage.rpc(damage_per_tick, false)
