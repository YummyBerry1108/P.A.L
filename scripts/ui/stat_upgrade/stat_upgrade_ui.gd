extends Control

@export_category("Basic")
@export var choose_time: int
@export_category("Resource")
@export var upgrade_card_scene: PackedScene
@export var container: HBoxContainer
@export var upgrade_timer: Timer
@export var upgrade_timer_label: Label
@export var background: ColorRect

var current_cards_data: Array[StatUpgradeData] = []
var upgrades_ref: StatUpgradeManager
## toggle on little level up (1 level)

func _ready() -> void:
	hide()
	#UpgradeEventbus.local_stat_upgrade_ready.connect(_on_stat_upgrade_ready)
	UpgradeEventbus.show_stat_upgrades.connect(_on_show_stat_upgrades)
	for i in range(3):
		var card = upgrade_card_scene.instantiate()
		container.add_child(card)
		card.upgrade_selected.connect(_on_card_selected)
	
func _process(delta: float) -> void:
	upgrade_timer_label.text = str(int(ceil(upgrade_timer.time_left)))

#func _on_stat_upgrade_ready(stat_upgrade: StatUpgradeManager) -> void:
	#upgrades_ref = stat_upgrade

func _on_show_stat_upgrades(options: Array[StatUpgradeData]) -> void:
	if not GameManager.local_player.is_alive:
		return

	current_cards_data = options
	var card_nodes = container.get_children()
	
	for i in range(options.size()):
		card_nodes[i].setup(options[i])

	show()
	upgrade_timer.start(choose_time)

#@rpc("authority", "call_local", "reliable")
#func show_upgrades() -> void:
	#if not GameManager.local_player.is_alive:
		#return
#
	#show()
	#upgrade_timer.start(choose_time)
	#for child in container.get_children():
		#var choose_stat: StatUpgradeData = upgrades_ref.get_children().pick_random()
		#child.setup(choose_stat)
	

func _on_card_selected(upgrade_id: String) -> void:
	_confirm_selection(upgrade_id)
	

func _on_timer_timeout() -> void:
	if current_cards_data.is_empty():
		return
	var random_data: StatUpgradeData = current_cards_data.pick_random()
	_confirm_selection(random_data.upgrade_id)
	
func _confirm_selection(upgrade_id: String) -> void:
	hide()
	upgrade_timer.stop()
	current_cards_data.clear()
	GameManager.choosed_upgrade.rpc_id(1)
	UpgradeEventbus.stat_upgrade.emit(upgrade_id)
