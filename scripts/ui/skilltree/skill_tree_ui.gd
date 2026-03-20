extends Control

@export_category("Basic")
@export var choose_time: int
@export var skill_icon: Texture
@export_category("MainResource")
@export var skill_tree_data: SkillTreeData
@export var path_containers: Array[HBoxContainer]
@export var upgrade_timer: Timer
@export_category("UIResource")
@export var texture_rect: TextureRect
@export var button_scene: PackedScene
@export var upgrade_timer_label: Label
@export var upgrade_point_label: Label

@onready var tooltip_panel: PanelContainer = $TooltipPanel
@onready var tooltip_name: Label = $TooltipPanel/VBoxContainer/NameLabel
@onready var tooltip_desc: Label = $TooltipPanel/VBoxContainer/DescLabel

var upgrade_point: int = 0

func _ready() -> void:
	hide()
	tooltip_panel.hide()
	texture_rect.texture = skill_icon
	_generate_ui_from_data()
	
func _process(delta: float) -> void:
	upgrade_timer_label.text = str(int(ceil(upgrade_timer.time_left)))
	upgrade_point_label.text = "Point: " + str(upgrade_point)
	if tooltip_panel.visible:
		tooltip_panel.global_position = get_global_mouse_position() + Vector2(15, 15)
	
func _generate_ui_from_data() -> void:
	if not skill_tree_data: return
	
	for container in path_containers:
		for child in container.get_children():
			child.queue_free()
			
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
			btn.setup(node_data.skill_id) # 自動傳入 UID
			btn.mouse_entered.connect(_show_tooltip.bind(node_data))
			btn.mouse_exited.connect(_hide_tooltip)

## Manage Upgrade and Multiplayer Logic
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

## Manage Tooltip Logic
func _show_tooltip(data: SkillNodeData) -> void:
	tooltip_name.text = data.skill_name
	tooltip_desc.text = data.skill_description
	tooltip_panel.show()

func _hide_tooltip() -> void:
	tooltip_panel.hide()
