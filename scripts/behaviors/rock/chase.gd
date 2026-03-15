extends Behavior

func _physics_update(delta: float) -> void:
	var target_pos: Vector2 = actor.get_nearest_player()
	actor.direction = actor.global_position.direction_to(target_pos)
	var desired_velocity = actor.direction * actor.max_speed * actor.speed_multiplier
	var steering = (desired_velocity - actor.velocity).limit_length(actor.steer_force)
	actor.velocity += steering * delta
