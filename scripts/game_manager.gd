extends Node

# Autoload named GameManager

signal pause_state_changed(is_paused: bool)

var local_player: Player # the player that user control
var players_upgraded: Array[int] = [] # use multiplayer id to record

func _ready() -> void:
	Lobby.player_disconnected.connect(_on_player_disconnected)

## Only server can call this rpc to stop game, true is stop
@rpc("authority", "call_local", "reliable")
func change_pause_state(state: bool) -> void:
	get_tree().paused = state
	pause_state_changed.emit(state)

## Apply upgrade effect and check how many player have upgraded
@rpc("any_peer", "call_local", "reliable")
func submit_upgrade(upgrade_id: String) -> void:
	if not multiplayer.is_server():
		return
		
	var sender_id = multiplayer.get_remote_sender_id()
	var player_node = _get_player_node(sender_id)
	
	if sender_id in players_upgraded:
		return
		
	players_upgraded.append(sender_id)
	if player_node:
		player_node.upgrade_stat.rpc(upgrade_id)
	else:
		push_error("無法找到玩家節點，ID: ", sender_id)
	_check_resume()

## Handle player disconnect when upgrading
func _on_player_disconnected(id: int) -> void:
	if not multiplayer.is_server():
		return
	if id in players_upgraded:
		players_upgraded.erase(id)
	call_deferred("_check_resume")

## Resume game when all player have upgraded
func _check_resume() -> void:
	var player_amount: int = get_tree().get_nodes_in_group("players").size()
	if players_upgraded.size() >= player_amount:
		change_pause_state.rpc(false)
		players_upgraded.clear()

## Get player node by group
func _get_player_node(peer_id: int) -> Node:
	var target_name: String = str(peer_id)
	for player: Player in get_tree().get_nodes_in_group("players"):
		if player.name == target_name:
			return player
	return null
