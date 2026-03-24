extends Control

@export_category("Basic")
@export var choose_time: int
@export_category("Resource")
@export var upgrade_card_scene: PackedScene
@export var container: HBoxContainer
@export var upgrade_timer: Timer
@export var upgrade_timer_label: Label
@export var background: ColorRect

var upgrades_ref: StatUpgradeManager
## toggle on little level up (1 level)

func _ready() -> void:
	UpgradeEventbus.local_stat_upgrade_ready.connect(_on_stat_upgrade_ready)
	hide()


func _process(delta: float) -> void:
	upgrade_timer_label.text = str(int(ceil(upgrade_timer.time_left)))

func _on_stat_upgrade_ready(stat_upgrade: StatUpgradeManager) -> void:
	upgrades_ref = stat_upgrade
	for i in range(3):
		var card = upgrade_card_scene.instantiate()
		container.add_child(card)
		card.upgrade_selected.connect(_on_card_selected)

func _on_level_up() -> void:
	GameManager.change_pause_state.rpc(true)
	show_upgrades.rpc()
	
@rpc("authority", "call_local", "reliable")
func show_upgrades() -> void:
	if not GameManager.local_player.is_alive:
		return

	show()
	upgrade_timer.start(choose_time)
	for child in container.get_children():
		var choose_stat: StatUpgradeData = upgrades_ref.get_children().pick_random()
		child.setup(choose_stat)
	

func _on_card_selected(upgrade_id: String) -> void:
	hide()
	upgrade_timer.stop()
	#for child in container.get_children():
		#child.queue_free()

	GameManager.submit_upgrade.rpc_id(1)

func _on_timer_timeout() -> void:
	if container.get_child_count() == 0:
		return
	var card = container.get_children().pick_random()
	_on_card_selected(card.stat_id)
