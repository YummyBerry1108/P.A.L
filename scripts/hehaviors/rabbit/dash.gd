extends Behavior

@export var duration: float = 1
var time_left: float = 0.0

func _enter_behavior() -> void:
	actor.dash_start_point = actor.global_position
	time_left = duration
	actor.set_collision_mask_value(PhysicsLayers.ENEMY, false)
	actor.set_collision_layer_value(PhysicsLayers.ENEMY, false)

func _physics_update(delta: float) -> void:
	actor.velocity = actor.direction * actor.dash_speed * actor.speed_multiplier

	time_left -= delta
	if time_left <= 0:
		behavior_tree_component.change_behavior("idle")

func _exit_behavior() -> void:
	actor.dash_finish_point = actor.global_position
	actor.set_collision_mask_value(PhysicsLayers.ENEMY, true)
	actor.set_collision_layer_value(PhysicsLayers.ENEMY, true)
