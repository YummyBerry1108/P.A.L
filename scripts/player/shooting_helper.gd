class_name ShootingHelper extends Node

func set_shoot_timer(wait: float, skill_data: SkillData, projectile_global_rotation: float, skill_scene_name: String) -> void:	
	var repeats = skill_data.multishot
	for i in repeats:
		var final_rotation = projectile_global_rotation + deg_to_rad(randf_range(-skill_data.rotation_randomization/2, skill_data.rotation_randomization/2))
		get_parent().owner.projectiles.add_projectile(skill_data, skill_scene_name, final_rotation)
		await get_tree().create_timer(wait).timeout
	queue_free()
