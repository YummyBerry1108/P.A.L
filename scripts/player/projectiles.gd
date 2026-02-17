extends Node

var loaded_skills: Dictionary = {}

func add_projectile(skill_data: SkillData, skill_scene_name: String, projectile_global_rotation: float):
	if not loaded_skills.has(skill_scene_name):
		loaded_skills[skill_scene_name] = load(skill_scene_name)

	var new_projectile: Projectile = loaded_skills[skill_scene_name].instantiate()
	new_projectile.global_position = owner.global_position
	new_projectile.global_rotation = projectile_global_rotation
	if multiplayer.is_server():
		new_projectile.damage = skill_data.projectile_damage + owner.damage
		new_projectile.crit_chance = skill_data.crit_chance
		new_projectile.crit_damage_multiplier = skill_data.crit_damage_multiplier
		new_projectile.status_effects = skill_data.status_effects

	add_child(new_projectile, true)
