extends Node

var loaded_skills: Dictionary = {}

@rpc("authority", "call_local", "reliable")
func add_projectile(skill_scene_name: String, projectile_global_position: Vector2, projectile_global_rotation: float, player_damage: float):
	if not loaded_skills.has(skill_scene_name):
		loaded_skills[skill_scene_name] = load(skill_scene_name)

	var new_projectile: Projectile = loaded_skills[skill_scene_name].instantiate()
	new_projectile.global_position = projectile_global_position
	new_projectile.global_rotation = projectile_global_rotation
	new_projectile.damage += player_damage
	
	add_child(new_projectile, true)
