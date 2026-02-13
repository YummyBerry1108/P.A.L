class_name ShootingHelper extends Node

var repeat = 0

func set_shoot_timer(wait, repeats, player: CharacterBody2D, projectile: Projectile, rot: float) -> void:
	repeat = repeats
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait
	timer.timeout.connect(func():
		if repeat == 0:
			timer.stop()
			queue_free()
			return
			
		projectile.position = player.position
		projectile.rotation = rot
		#projectile.look_at(player.get_global_mouse_position())
		player.get_node("Projectiles").add_child(projectile)
	)
	
	timer.start()
