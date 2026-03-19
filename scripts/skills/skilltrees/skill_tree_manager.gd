extends Node
class_name SkillTreeManager

@export var actor: SkillData
@export var skill_tree_data: SkillTreeData

var uid_to_node: Dictionary[String, SkillNodeData] = {}
var unlocked_nodes: Array[String] = [] # 可以被點擊的節點
var active_nodes: Array[String] = []   # 已經點亮/升級的節點

func _ready() -> void:
	UpgradeEventbus.request_upgrade.connect(request_upgrade)
	
	if skill_tree_data == null:
		push_warning("還沒有放入技能樹資料！")
		return
		
	for skill_path: SkillPathData in skill_tree_data.skill_paths:
		for skill_node: SkillNodeData in skill_path.skill_nodes:
			if skill_node.upgrade_id == "": continue
			uid_to_node[skill_node.upgrade_id] = skill_node
			
	for skill_path: SkillPathData in skill_tree_data.skill_paths:
		if skill_path.skill_nodes.size() > 0:
			unlocked_nodes.append(skill_path.skill_nodes[0].upgrade_id)
			UpgradeEventbus.on_skill_unlocked.emit(skill_path.skill_nodes[0].upgrade_id)

func request_upgrade(upgrade_id: String) -> void:
	if not is_multiplayer_authority():
		return
	upgrade_node(upgrade_id)

func upgrade_node(upgrade_id: String) -> void:
	if not uid_to_node.has(upgrade_id): return
	if active_nodes.has(upgrade_id): return
	if not unlocked_nodes.has(upgrade_id): return
	
	var current_node: SkillNodeData = uid_to_node[upgrade_id]

	active_nodes.append(upgrade_id)
	UpgradeEventbus.on_skill_active.emit(upgrade_id)
	
	for next_uid in current_node.next_node_uids:
		if uid_to_node.has(next_uid) and not unlocked_nodes.has(next_uid):
			unlocked_nodes.append(next_uid)
			UpgradeEventbus.on_skill_unlocked.emit(next_uid)
	_sync_apply_upgrade.rpc(upgrade_id)

@rpc("any_peer", "call_local", "reliable")
func _sync_apply_upgrade(upgrade_id: String) -> void:
	var current_node: SkillNodeData = uid_to_node[upgrade_id]
	for effect: SkillUpgrade in current_node.upgrade_effects:
		actor.apply_upgrade(effect)

func _unhandled_input(event) -> void:
	if not is_multiplayer_authority():
		return
	if event.is_action_pressed("test_upgrade"):
		print("T is pressed: 嘗試升級 snowball_scale+")
		upgrade_node("snowball_scale+")
