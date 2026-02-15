class_name ShootingHelper extends Node

func set_shoot_timer(wait: float, repeats: int, player_global_position: Vector2, projectile_global_rotation: float, skill_scene_name: String, player_damage: float) -> void:	
	for i in repeats:
		get_parent().owner.projectiles.add_projectile.rpc(skill_scene_name, player_global_position, projectile_global_rotation, player_damage)
		await get_tree().create_timer(0.1).timeout
	queue_free()
