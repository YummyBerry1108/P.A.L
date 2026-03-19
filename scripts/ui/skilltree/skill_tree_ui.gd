extends Control

@export_category("Basic")
@export var choose_time: int
@export_category("MainResource")
@export var skill_tree_data: SkillTreeData
@export var path_containers: Array[HBoxContainer]
@export var upgrade_timer: Timer
@export_category("UIResource")
@export var button_scene: PackedScene
@export var upgrade_timer_label: Label
@export var upgrade_point_label: Label

var upgrade_point: int = 0

func _ready() -> void:
	hide()
	_generate_ui_from_data()
	
func _process(delta: float) -> void:
	upgrade_timer_label.text = str(int(ceil(upgrade_timer.time_left)))
	upgrade_point_label.text = "Point: " + str(upgrade_point)
	
func _generate_ui_from_data() -> void:
	if not skill_tree_data: return

	# 確保路徑數量與容器數量匹配
	var path_count = min(skill_tree_data.skill_paths.size(), path_containers.size())

	for i in range(path_count):
		var path_data = skill_tree_data.skill_paths[i]
		var container = path_containers[i]

		# 根據資料檔的節點數量，動態生成按鈕
		for node_data in path_data.skill_nodes:
			
			var btn = button_scene.instantiate()
			btn.upgrade_selected.connect(_on_upgrade_selected)
			container.add_child(btn)
			btn.setup(node_data.upgrade_id) # 自動傳入 UID
			
func _on_level_up() -> void:
	GameManager.change_pause_state.rpc(true)
	show_upgrades.rpc()
	
@rpc("authority", "call_local", "reliable")
func show_upgrades() -> void:
	if not GameManager.local_player.is_alive:
		return
		
	upgrade_point += 1
	show()
	upgrade_timer.start(choose_time)

func _on_upgrade_selected() -> void:
	upgrade_point -= 1
	if upgrade_point == 0:
		hide()
		_end_upgrade()

func _on_timer_timeout() -> void:
	hide()
	_end_upgrade()
	
func _end_upgrade() -> void:
	GameManager.skill_upgrade.rpc_id(1)
