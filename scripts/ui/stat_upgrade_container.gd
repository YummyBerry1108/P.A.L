extends HBoxContainer

# Only add stat_upgrade button as its child
@export_category("Basic")
@export var choose_time: int
@export_category("Resource")
@export var upgrade_card_scene: PackedScene
@export var stat_upgrades: Node
@export var upgrade_timer: Timer
@export var upgrade_timer_label: Label
@export var background: ColorRect

## toggle on little level up (1 level)

func _ready() -> void:
	background.hide()
	upgrade_timer_label.hide()

func _process(delta: float) -> void:
	upgrade_timer_label.text = str(int(ceil(upgrade_timer.time_left)))

func _on_level_up() -> void:
	GameManager.change_pause_state.rpc(true)
	show_upgrades.rpc()
	
@rpc("authority", "call_local", "reliable")
func show_upgrades() -> void:
	if not GameManager.local_player.is_alive:
		return
		
	for child in get_children():
		child.queue_free()
	show()
	background.show()
	upgrade_timer_label.show()
	
	
	upgrade_timer.start(choose_time)
	
	for i in range(3):
		var card = upgrade_card_scene.instantiate()
		add_child(card)
		var choose_stat: StatUpgradeData = stat_upgrades.get_children().pick_random()
		card.setup(choose_stat.upgrade_id, choose_stat.title, choose_stat.description)

		card.upgrade_selected.connect(_on_card_selected)

func _on_card_selected(upgrade_id: String) -> void:
	upgrade_timer.stop()
	
	background.hide()
	upgrade_timer_label.hide()
	hide()
	for child in get_children():
		child.queue_free()

	GameManager.submit_upgrade.rpc_id(1, upgrade_id)

func _on_timer_timeout() -> void:
	var card = get_children().pick_random()
	_on_card_selected(card.current_upgrade_id)
