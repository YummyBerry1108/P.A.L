extends Label

# Mode of Node is Always

func _ready():
	hide()
	GameManager.pause_state_changed.connect(_on_pause_state_changed)
	GameManager.player_amount_changed.connect(_on_player_amount_changed)
	
func _on_pause_state_changed(is_paused: bool) -> void:
	visible = is_paused

func _on_level_up() -> void:
	text = "Waiting for other player..."

func _on_player_amount_changed() -> void:
	var upgraded_player: int = GameManager.players_upgraded.size()
	var total_player: int = get_tree().get_nodes_in_group("players").size()
	var player_message: String = "(" + str(upgraded_player) + "/" + str(total_player) + ")"
	text = "Waiting for other player... " + player_message

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"): 
		text = "Game Pause!"
		if multiplayer.is_server():
			var new_state = not get_tree().paused
			GameManager.change_pause_state.rpc(new_state)
