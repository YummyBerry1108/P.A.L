extends Node
class_name StatUpgradeManager

func _ready() -> void:
	if not is_multiplayer_authority():
		return
	#call_deferred("_announce_to_ui")

#func _announce_to_ui() -> void:
	#if is_multiplayer_authority():
		#UpgradeEventbus.local_stat_upgrade_ready.emit(self)

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

@rpc("any_peer", "call_local", "reliable")
func submit_upgrade_selection(selected_id: String) -> void:
	if not multiplayer.is_server():
		return
		
	var sender_id = multiplayer.get_remote_sender_id()
	#apply_upgrade_to_player(sender_id, selected_id)
