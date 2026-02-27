extends HBoxContainer

@export var upgrade_card_scene: PackedScene 	
@export var stat_upgrades: Node
# Only add stat_upgrade button as its child

## toggle on little level up (1 level)
func show_upgrades():
	
	GameManager.request_toggle_pause.rpc_id(1)
	
	for child in get_children():
		child.queue_free()
	show()
		
	for i in range(3):
		var card = upgrade_card_scene.instantiate()
		add_child(card)
		var choose_stat: StatUpgradeData = stat_upgrades.get_children().pick_random()
		card.setup(choose_stat.upgrade_id, choose_stat.title, choose_stat.description)

		card.upgrade_selected.connect(_on_card_selected)

func _on_card_selected(upgrade_id: String):
	print("玩家選擇了: ", upgrade_id)
	
	hide()
	for child in get_children():
		child.queue_free()
		
	GameManager.request_toggle_pause.rpc_id(1)
