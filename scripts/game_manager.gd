extends Node

# Autoload named GameManager

signal pause_state_changed(is_paused: bool)

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
