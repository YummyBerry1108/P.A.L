class_name LifeStealModifier extends SkillModifier

@export_range(0.0, 1.0, 0.01) var lifesteal_ratio: float = 0.2 # 吸血比例 20%

func on_post_hit(context: SkillContext) -> void:
	if not context.source or not context.source.has_method("heal"):
		return
	var heal_amount = context.final_damage * lifesteal_ratio
	if heal_amount > 0:
		context.source.heal.rpc(heal_amount)
