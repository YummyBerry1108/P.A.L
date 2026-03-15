extends Behavior

func _physics_update(delta: float) -> void:
	var target_pos: Vector2 = actor.get_nearest_player()
	actor.velocity = actor.global_position.direction_to(target_pos) * actor.speed * actor.speed_multiplier
	
