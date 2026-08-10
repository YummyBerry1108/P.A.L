class_name LifeStealEffect extends StatusEffectRes

# Duration should be 0 to let effect only apply 1 time

@export var lifesteal_rate: float
var healer: CharacterBody2D
var damage_dealt: float

func _on_tick(actor: Node2D, delta: float, instance: EffectInstance) -> void:
	apply_heal(actor)

func apply_heal(actor: Node2D) -> void:
	if "heal" in healer:
		healer.heal.rpc(damage_dealt * lifesteal_rate)
