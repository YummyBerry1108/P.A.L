extends Node
class_name StatUpgradeManager

func _ready() -> void:
	UpgradeEventbus.stat_upgrade_selected.connect(_on_upgrade_selected)

func show_upgrades() -> void:
	if not multiplayer.is_server():
		return
		
	var available_stats: Array = get_children()
	if available_stats.is_empty():
		return
		
	var chosen_ids: Array[String] = []
	for i in range(3):
		var rand_stat = available_stats.pick_random()
		chosen_ids.append(rand_stat.name)
		
	_rpc_show_upgrades.rpc(chosen_ids)

@rpc("authority", "call_local", "reliable")
func _rpc_show_upgrades(chosen_ids: Array[String]) -> void:
	var options_data: Array[StatUpgradeData] = []
	for id in chosen_ids:
		var node = get_node_or_null(id)
		if node and node is StatUpgradeData:
			options_data.append(node)
			
	UpgradeEventbus.show_stat_upgrades.emit(options_data)

func _on_upgrade_selected(upgrade_id: String) -> void:
	GameManager.choosed_upgrade.rpc_id(1)
	var local_player = GameManager.local_player
	if is_instance_valid(local_player):
		local_player.player_stat.apply_upgrade.rpc(upgrade_id)
