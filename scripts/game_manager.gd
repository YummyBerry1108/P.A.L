extends Node

# Autoload named GameManager

signal pause_state_changed(is_paused: bool)

var total_player: int = 0
var players_upgraded: int = 0

@rpc("any_peer", "call_local", "reliable")
func request_toggle_pause():
	if not multiplayer.is_server():
		return
		
	var new_state = not get_tree().paused
	apply_pause_state.rpc(new_state)

@rpc("authority", "call_local", "reliable")
func apply_pause_state(state: bool):
	get_tree().paused = state
	pause_state_changed.emit(state)

@rpc("any_peer", "call_local", "reliable")
func submit_upgrade(upgrade_id: String):
	if not multiplayer.is_server():
		return
		
	var sender_id = multiplayer.get_remote_sender_id()
	var player_node = _get_player_node(sender_id)
	
	if player_node:
		apply_upgrade_effect(player_node, upgrade_id)
	else:
		push_error("無法找到玩家節點，ID: ", sender_id)

func _get_player_node(peer_id: int) -> Node:
	var target_name = str(peer_id)
	for player in get_tree().get_nodes_in_group("players"):
		if player.name == target_name:
			return player
	return null

func apply_upgrade_effect(player_node: Player, upgrade_id: String):
	player_node.upgrade_stat.rpc(upgrade_id)
