class_name ShootingHelper extends Node

func set_shoot_timer(wait, repeats, player: CharacterBody2D, projectile, rot: float, skill_node) -> void:
	projectile.queue_free()
	for i in repeats:
		var new_projectile: Projectile = skill_node.instantiate()
		new_projectile.global_position = player.global_position
		new_projectile.global_rotation = rot
		#print(new_projectile.global_position, " ", new_projectile.global_rotation, " ", new_projectile.name)
		player.get_node("Projectiles").add_child(new_projectile)
		await get_tree().create_timer(0.1).timeout
	queue_free()
