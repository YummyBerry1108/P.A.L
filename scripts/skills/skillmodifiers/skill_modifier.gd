class_name SkillModifier extends Resource

@export var is_active: bool = true
var id: String = ""

func _init() -> void:
	id = get_script().get_global_name()

func on_projectile_spawned(context: SkillContext) -> void:
	pass

func on_pre_hit(context: SkillContext) -> void:
	pass

func on_post_hit(context: SkillContext) -> void:
	pass
# 未實作
func on_kill(context: SkillContext) -> void:
	pass

func on_projectile_expired(context: SkillContext) -> void:
	pass
