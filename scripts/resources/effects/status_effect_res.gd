extends Resource
class_name StatusEffectRes

enum StackMode { 
	REFRESH,
	STACK,
	IGNORE
}

var effect_name: String = "Effect"
@export var stack_mode: StackMode = StackMode.REFRESH
@export var duration: float = 3.0
@export var tick_interval: float = 1.0

func on_apply(actor: CharacterBody2D) -> void:
	pass

func on_tick(actor: Node2D, delta: float, instance: EffectInstance) -> void:
	pass

func on_remove(actor: CharacterBody2D) -> void:
	pass

func removed(actor: CharacterBody2D) -> void:
	pass

func on_stack(existing_instance: EffectInstance, new_data: StatusEffectRes):
	existing_instance.time_left = new_data.duration

func on_refresh(actor: CharacterBody2D) -> void:
	pass
