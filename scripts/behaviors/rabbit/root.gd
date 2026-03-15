extends Behavior

func _enter_behavior() -> void:
	var dist = actor.global_position.distance_to(actor.get_nearest_player())
	
	if dist <= 500:
		behavior_tree_component.change_behavior("target")
	else:
		behavior_tree_component.change_behavior("chase")
