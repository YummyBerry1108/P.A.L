extends Node
class_name SkillTreeManager

@export var actor: SkillData
@export var curr_skill_tree_data: SkillTreeData
var skill_trees: Array[SkillTreeData]
var skill_id_to_name: Dictionary[String, String] # to know this upgrade under which skill

var uid_to_node: Dictionary[String, SkillNodeData] = {}
var unlocked_nodes: Array[String] = [] # 可以被點擊的節點
var active_nodes: Array[String] = []   # 已經點亮/升級的節點

func _ready() -> void:
	_put_skill_trees()
	_init_manager()
	if not is_multiplayer_authority():
		return
	UpgradeEventbus.skill_upgrade.connect(skill_upgrade)
	call_deferred("_announce_to_ui")
	
func _announce_to_ui() -> void:
	if is_multiplayer_authority():
		UpgradeEventbus.local_manager_ready.emit(self)
		
func _put_skill_trees() -> void:
	var dir = DirAccess.open("res://resources/skill_trees/")
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			#print("Found file: " + file_name)
			var skill_tree_data: SkillTreeData = load("res://resources/skill_trees/" + file_name)
			skill_trees.append(skill_tree_data)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func _init_manager() -> void:
	for skill_tree_data in skill_trees:
		for skill_path: SkillPathData in skill_tree_data.skill_paths:
			if skill_path.skill_nodes.size() > 0:
				unlocked_nodes.append(skill_path.skill_nodes[0].skill_id)
				UpgradeEventbus.on_skill_unlocked.emit(skill_path.skill_nodes[0].skill_id)
			
			for skill_node: SkillNodeData in skill_path.skill_nodes:
				if skill_node.skill_id == "": continue
				uid_to_node[skill_node.skill_id] = skill_node
				skill_id_to_name[skill_node.skill_id] = skill_tree_data.skill_name

func skill_upgrade(skill_id: String) -> void:
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

## apply upgrade on every client
@rpc("any_peer", "call_local", "reliable")
func _sync_apply_upgrade(skill_id: String) -> void:
	var current_node: SkillNodeData = uid_to_node[skill_id]
	var skill_name: String = skill_id_to_name[skill_id]
	for effect: SkillUpgrade in current_node.upgrade_effects:
		owner.skills[skill_name].apply_upgrade(effect)

# Support Functions

func is_node_unlocked(id: String) -> bool:
	return unlocked_nodes.has(id)

func is_node_active(id: String) -> bool:
	return active_nodes.has(id)
