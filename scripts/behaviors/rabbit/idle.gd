extends Behavior

@export var duration: float = 0.5
var time_left: float = 0.0

func _enter_behavior() -> void:
	time_left = duration

func _physics_update(delta: float) -> void:
	actor.velocity = Vector2.ZERO
	
	time_left -= delta
	if time_left <= 0:
		behavior_tree_component.change_behavior("root")
