class_name BehaviorTreeComponent extends Node

@export var actor: CharacterBody2D
@export var default_behavior: Behavior
@onready var label: Label = get_node_or_null("../Label")

var current_behavior: Behavior
var behaviors: Array[Behavior]

func _ready() -> void:
	for behavior in get_children() as Array[Behavior]:
		behaviors.append(behavior)
	#behaviors = get_children() as Array[Behavior]
	
	change_behavior("default")

func check_current_behavior(behavior: Behavior) -> bool:
	return current_behavior == behavior

func change_behavior(target_behavior_name: String) -> bool:
	var target_behavior: Behavior
	if target_behavior_name == "default":
		if current_behavior:
			current_behavior._exit_behavior()
		current_behavior = default_behavior
		current_behavior._enter_behavior()
		return true
	for behavior in behaviors:
		if behavior.name.to_snake_case() == target_behavior_name:
			target_behavior= behavior
			break
	if !target_behavior:
		return false
	
	if current_behavior:
		current_behavior._exit_behavior()
	current_behavior = target_behavior
	current_behavior._enter_behavior()
	return true

func _physics_process(delta: float) -> void:
	if !multiplayer.is_server(): return
	current_behavior._physics_update(delta)
	actor.move_and_slide()
	
func _process(delta: float) -> void:
	if !multiplayer.is_server(): return
	if label:
		label.text = current_behavior.name
	current_behavior._update(delta)
