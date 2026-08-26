class_name AlternatingAnimationModifier extends SkillModifier

@export var anim_a: String = "attack"
@export var anim_b: String = "attack_counterclockwise"

func on_projectile_spawned(context: SkillContext) -> void:
	if not context.projectile or not context.skill_data:
		return
		
	# 決定本次動畫並塞入 Projectile 變數
	var anim = anim_a if context.skill_data.spawn_count % 2 == 0 else anim_b
	context.projectile.set("custom_anim_name", anim)
