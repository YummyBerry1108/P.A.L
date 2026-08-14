class_name AlternatingAnimationModifier extends SkillModifier

@export var anim_a: String = "attack"
@export var anim_b: String = "attack_counterclockwise"

var attack_count: int = 0

func on_projectile_spawned(context: SkillContext) -> void:
	if not context.projectile:
		return
		
	# 決定本次動畫並塞入 Projectile 變數
	var anim = anim_a if attack_count % 2 == 0 else anim_b
	context.projectile.set("custom_anim_name", anim)
	attack_count += 1
