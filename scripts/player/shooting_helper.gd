class_name ShootingHelper extends Node

func set_shoot_timer(wait: float, skill_data: SkillData, projectile_global_rotation: float, skill_scene_name: String, spawn_seed: int) -> void:
	# 用權威端廣播下來的種子，確保每個 peer 的散射角與投射物內部亂數都一致
	var rng := RandomNumberGenerator.new()
	rng.seed = spawn_seed

	var repeats = skill_data.multishot
	for i in repeats:
		var final_rotation = projectile_global_rotation + deg_to_rad(rng.randf_range(-skill_data.rotation_randomization/2, skill_data.rotation_randomization/2))
		get_parent().owner.projectiles.add_projectile(skill_data, skill_scene_name, final_rotation, rng.randi())
		await get_tree().create_timer(wait).timeout
	queue_free()
