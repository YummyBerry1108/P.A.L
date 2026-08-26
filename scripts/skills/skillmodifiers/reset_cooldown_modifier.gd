class_name ResetCooldownModifier extends SkillModifier

@export var skill_key: String = "tachi"

func on_projectile_expired(context: SkillContext) -> void:
	# 僅在總命中次數為 1 時觸發
	if not context.hit_count == 1 or not context.source:
		return
	var attack_behavior = context.source.get_node_or_null("Behaviors/Attack")
	if not attack_behavior or not attack_behavior.has_method("reset_skill_cooldown"):
		return
	attack_behavior.reset_skill_cooldown(skill_key)
