class_name EffectComponent extends Node

var active_effects: Array[EffectInstance] = []
@onready var actor: CharacterBody2D = get_parent()

func add_effect(res: StatusEffectRes) -> void:
	var existing_effect = null
	for inst in active_effects:
		if inst.data.effect_name == res.effect_name:
			existing_effect = inst
			break
	
	if existing_effect:
		match res.stack_mode:
			StatusEffectRes.StackMode.REFRESH:
				existing_effect.time_left = res.duration
				existing_effect.data.on_refresh(actor)
				return 
			StatusEffectRes.StackMode.IGNORE:
				return
			StatusEffectRes.StackMode.STACK:
				pass
	var new_instance = EffectInstance.new(res)
	active_effects.append(new_instance)
	
	res.on_apply(actor)

func _process(delta: float) -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		var inst = active_effects[i]
		inst.time_left -= delta
		
		inst.data.on_tick(actor, delta, inst)
		
		if inst.time_left <= 0:
			inst.data.on_remove(actor)
			active_effects.remove_at(i)
			inst.data.removed(actor)

func get_speed_multiplier() -> float:
	var mult = 1.0
	for inst in active_effects:
		if inst.data is SlowEffect:
			mult *= inst.data.speed_multiplier
	return mult
