extends Behavior

@export var duration: float = 0.5
var time_left: float = 0.0

func _enter_behavior() -> void:
	time_left = duration

func _physics_update(delta: float) -> void:
	var target_pos: Vector2 = actor.get_nearest_player()
	actor.direction = actor.global_position.direction_to(target_pos)
	
	actor.velocity = actor.direction * actor.speed * actor.speed_multiplier
	
	time_left -= delta
	if time_left <= 0:
		behavior_tree_component.change_behavior("root")

#func _update(delta: float) -> void:
