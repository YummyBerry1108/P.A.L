extends Node

var loaded_skills: Dictionary = {}

func add_projectile(skill_data: SkillData, skill_scene_name: String, projectile_global_rotation: float) -> void:
	if not loaded_skills.has(skill_scene_name):
		loaded_skills[skill_scene_name] = load(skill_scene_name)

	var new_projectile: Projectile = loaded_skills[skill_scene_name].instantiate()
	new_projectile.global_position = owner.global_position
	new_projectile.global_rotation = projectile_global_rotation
	new_projectile.scale = Vector2(skill_data.scale, skill_data.scale)
	new_projectile.actor = get_parent()
	new_projectile.skill_data = skill_data
	
	if multiplayer.is_server():
		var spawn_ctx = SkillContext.new(skill_data, owner)
		spawn_ctx.projectile = new_projectile
		spawn_ctx.base_damage = skill_data.projectile_damage + owner.player_stat.damage
		spawn_ctx.final_damage = spawn_ctx.base_damage
		skill_data.trigger_projectile_spawned(spawn_ctx)
		new_projectile.damage = spawn_ctx.final_damage
	
	add_child(new_projectile, true)
	new_projectile.owner = owner
