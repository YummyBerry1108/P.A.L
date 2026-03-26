extends Behavior

var time_left: float = 0.0

func _enter_behavior() -> void:
	time_left = actor.lock_duration
	
	var target_pos: Vector2 = actor.get_nearest_player()
	actor.direction = actor.global_position.direction_to(target_pos)

func _physics_update(delta: float) -> void:
	actor.velocity = Vector2.ZERO
	
	time_left -= delta
	if time_left <= 0:
		behavior_tree_component.change_behavior("dash")

#func _update(delta: float) -> void:
