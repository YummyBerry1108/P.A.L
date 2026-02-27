extends Label

# Mode of Node is Always

func _ready():
	hide()
	GameManager.pause_state_changed.connect(_on_pause_state_changed)

func _on_pause_state_changed(is_paused: bool) -> void:
	visible = is_paused

func _on_level_up() -> void:
	text = "Waiting for other player..."

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"): 
		text = "Game Pause!"
		if multiplayer.is_server():
			GameManager.request_toggle_pause.rpc_id(1)
