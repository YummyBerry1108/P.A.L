class_name INFHealEffect extends StatusEffectRes

func _on_tick(actor: Node2D, delta: float, instance: EffectInstance) -> void:
	if instance.ticks_left > 0:
		instance.tick_timer -= delta
		
		if instance.tick_timer <= 0:
			apply_heal(actor)
			instance.ticks_left -= 1
			instance.tick_timer += tick_interval
			instance.on_refresh()

func apply_heal(actor: Node2D) -> void:
	if "heal" in actor:
		actor.heal.rpc(actor.player_stat.heal_amount)
