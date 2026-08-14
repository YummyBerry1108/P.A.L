class_name BuffSelfOnHitModifier extends SkillModifier

@export var buff_effect: StatusEffectRes

func on_post_hit(context: SkillContext) -> void:
	# 只要有命中目標且施法者存在，就給施法者上 Buff
	if context.source and context.source.get("effect_component") and buff_effect:
		context.source.effect_component.add_effect(buff_effect)
