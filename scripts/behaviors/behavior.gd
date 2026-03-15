class_name Behavior extends Node

@export var actor: CharacterBody2D

var behavior_tree_component: BehaviorTreeComponent

func _ready() -> void:
	behavior_tree_component = get_parent() as BehaviorTreeComponent
	
func _physics_update(delta: float) -> void:
	pass

func _update(delta: float) -> void:
	pass

func _enter_behavior() -> void:
	pass

func _exit_behavior() -> void:
	pass
