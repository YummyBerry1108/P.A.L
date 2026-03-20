extends Node
class_name SkillTreeManager

@export var actor: SkillData
@export var skill_tree_data: SkillTreeData
@export var skill_name_to_tree: Dictionary[String, SkillTreeData]
@export var skill_name_to_actor: Dictionary[String, SkillData]

var uid_to_node: Dictionary[String, SkillNodeData] = {}
var unlocked_nodes: Array[String] = [] # 可以被點擊的節點
var active_nodes: Array[String] = []   # 已經點亮/升級的節點

func _ready() -> void:
	_init_skill_tree()
	if not is_multiplayer_authority():
		return
	call_deferred("_announce_to_ui")
	UpgradeEventbus.request_upgrade.connect(request_upgrade)
	UpgradeEventbus.change_tree_from_UI.connect(change_skill_tree.rpc)
	
func _announce_to_ui() -> void:
	if is_multiplayer_authority():
		UpgradeEventbus.local_manager_ready.emit(self)

func _init_skill_tree() -> void:
	if skill_tree_data == null:
		push_warning("還沒有放入技能樹資料！")
		return
	for key in skill_name_to_tree:
		var curr_skill_tree_data: SkillTreeData = skill_name_to_tree[key]
		for skill_path: SkillPathData in curr_skill_tree_data.skill_paths:
			for skill_node: SkillNodeData in skill_path.skill_nodes:
				if skill_node.skill_id == "": continue
				uid_to_node[skill_node.skill_id] = skill_node
				
		for skill_path: SkillPathData in curr_skill_tree_data.skill_paths:
			if skill_path.skill_nodes.size() > 0:
				unlocked_nodes.append(skill_path.skill_nodes[0].skill_id)
				UpgradeEventbus.on_skill_unlocked.emit(skill_path.skill_nodes[0].skill_id)

func request_upgrade(skill_id: String) -> void:
	if not is_multiplayer_authority():
		return
	upgrade_node(skill_id)

func upgrade_node(skill_id: String) -> void:
	if not uid_to_node.has(skill_id): return
	if active_nodes.has(skill_id): return
	if not unlocked_nodes.has(skill_id): return
	
	var current_node: SkillNodeData = uid_to_node[skill_id]

	active_nodes.append(skill_id)
	UpgradeEventbus.on_skill_active.emit(skill_id)
	
	for next_uid in current_node.next_node_uids:
		if uid_to_node.has(next_uid) and not unlocked_nodes.has(next_uid):
			unlocked_nodes.append(next_uid)
			UpgradeEventbus.on_skill_unlocked.emit(next_uid)
	_sync_apply_upgrade.rpc(skill_id)

@rpc("any_peer", "call_local", "reliable")
func _sync_apply_upgrade(skill_id: String) -> void:
	var current_node: SkillNodeData = uid_to_node[skill_id]
	for effect: SkillUpgrade in current_node.upgrade_effects:
		actor.apply_upgrade(effect)

@rpc("any_peer", "call_local", "reliable")
func change_skill_tree(skill_name: String) -> void:
	var skill_tree: SkillTreeData = skill_name_to_tree[skill_name]
	print("skill_tree: ", skill_tree)
	if not skill_tree:
		push_warning("找不到 SkillTreeData")
		return
	
	skill_tree_data = skill_tree
	actor = skill_name_to_actor[skill_name]
	if not is_multiplayer_authority():
		return
	UpgradeEventbus.after_change_tree.emit()
	
func _unhandled_input(event) -> void:
	if not is_multiplayer_authority():
		return
	if event.is_action_pressed("test_upgrade"):
		print("T is pressed: 嘗試升級 snowball_scale+")
		upgrade_node("snowball_scale+")

# Support Functions

func is_node_unlocked(id: String) -> bool:
	return unlocked_nodes.has(id)

func is_node_active(id: String) -> bool:
	return active_nodes.has(id)
	
