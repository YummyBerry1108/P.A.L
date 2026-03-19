extends Control

@export var skill_tree_data: SkillTreeData
@export var button_scene: PackedScene
@export var path_containers: Array[HBoxContainer] # 綁定編輯器中的三個水平容器

func _ready() -> void:
	hide()
	_generate_ui_from_data()

func _generate_ui_from_data() -> void:
	if not skill_tree_data: return

	# 確保路徑數量與容器數量匹配
	var path_count = min(skill_tree_data.skill_paths.size(), path_containers.size())

	for i in range(path_count):
		var path_data = skill_tree_data.skill_paths[i]
		var container = path_containers[i]
		print("Hey") 

		# 根據資料檔的節點數量，動態生成按鈕
		for node_data in path_data.skill_nodes:
			
			var btn = button_scene.instantiate()
			container.add_child(btn)
			btn.setup(node_data.upgrade_id) # 自動傳入 UID
