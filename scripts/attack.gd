extends Node

var cooldowns = {}

func run(args) -> void:
	if Input.is_action_pressed("shoot"):
		shoot(args["player"], args["skills"])

func shoot(player, skills):
	var now_time = Time.get_unix_time_from_system()
	for skill_name in skills:
		var skill_node = load("res://scenes/" + skill_name + ".tscn")
		if not cooldowns.has(skill_name) or now_time >= cooldowns[skill_name]:
			var new_projectile: Projectile = skill_node.instantiate()
			cooldowns[skill_name] = now_time + (1 / new_projectile.firerate)
			new_projectile.position = player.position
			new_projectile.look_at(player.get_global_mouse_position())
			player.get_node("Projectiles").add_child(new_projectile)
