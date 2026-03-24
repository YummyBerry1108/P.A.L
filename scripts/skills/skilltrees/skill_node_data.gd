extends Resource
class_name SkillNodeData

@export var icon: Texture2D = load("res://icon.svg")
@export var skill_id: String
@export var upgrade_effects: Array[SkillUpgrade] = []
@export var next_node_uids: Array[String] = []
@export var skill_name: String = "未命名技能"
@export_multiline var skill_description: String = ""
