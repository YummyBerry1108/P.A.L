class_name ShootingHelper extends Node

func set_shoot_timer(wait: float, skill_data: SkillData, projectile_global_rotation: float, skill_scene_name: String) -> void:	
	var repeats = skill_data.multishot
	for i in repeats:
		get_parent().owner.projectiles.add_projectile(skill_data, skill_scene_name, projectile_global_rotation)
		await get_tree().create_timer(wait).timeout
	queue_free()
