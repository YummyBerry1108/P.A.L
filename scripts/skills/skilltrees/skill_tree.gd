extends Node
class_name SkillTree
@export var actor: SkillData
@export var skill_paths: Array[SkillPath]

var uid_to_node: Dictionary[String, SkillNode] = {}

func _ready() -> void:
	for skill_path: SkillPath in skill_paths:
		for skill_node: SkillNode in skill_path.skill_nodes:
			uid_to_node[skill_node.upgrade_id] = skill_node

func upgrade_node(upgrade_id: String) -> void:
	var current_node: SkillNode = uid_to_node[upgrade_id]
	var upgrade_effect: SkillUpgrade = current_node.upgrade_effect
	
	current_node.trigger_active()
	for next_uid in current_node.next_node_uids:
		if uid_to_node.has(next_uid):
			uid_to_node[next_uid].trigger_unlocked()
	
	actor.apply_upgrade(upgrade_effect)

func _unhandled_input(event) -> void:
	if event.is_action_pressed("test_upgrade"):
		print("T is pressed")
		upgrade_node("snowball_scale+")
