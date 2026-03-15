extends Behavior

@export var knockback_component: KnockbackComponent

var knockback: Vector2
var knockback_timer: float

func _enter_behavior() -> void:
	knockback = knockback_component.knockback
	knockback_timer = knockback_component.knockback_timer

func _physics_update(delta: float) -> void:
	actor.velocity = knockback
	
	knockback_timer -= delta
	if knockback_timer <= 0:
		behavior_tree_component.change_behavior(behavior_tree_component.after_knockback_behavior.name.to_snake_case())
