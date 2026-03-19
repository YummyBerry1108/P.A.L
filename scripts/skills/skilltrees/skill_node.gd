extends Node
class_name SkillNode

@export var upgrade_effect: SkillUpgrade
@export var upgrade_id: String
@export var next_node_uids: Array[String] = []

var is_unlocked: bool = false
var is_active: bool = false

func trigger_active() -> void:
	is_active = true
	UpgradeEventbus.on_skill_active.emit(upgrade_id)

func trigger_unlocked() -> void:
	is_unlocked = true
	UpgradeEventbus.on_skill_unlocked.emit(upgrade_id)
