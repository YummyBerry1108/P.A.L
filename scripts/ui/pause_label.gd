extends Label

# Mode of Node is Always

func _ready():
	hide()
	GameManager.pause_state_changed.connect(_on_pause_state_changed)
	GameManager.player_amount_changed.connect(_on_player_amount_changed)
	
func _on_pause_state_changed(is_paused: bool) -> void:
	visible = is_paused
	if is_paused and get_tree().paused:
		text = "Game Pause!"

func _on_player_amount_changed() -> void:
	var upgraded_player: int = GameManager.players_upgraded.size()
	var total_player: int = get_tree().get_nodes_in_group("players").size()
	var player_message: String = "(" + str(upgraded_player) + "/" + str(total_player) + ")"
	text = "Waiting for other player... " + player_message
