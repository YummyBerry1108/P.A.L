extends Label

# Mode of Node is Always

func _ready():
	hide()
	GameManager.pause_state_changed.connect(_on_pause_state_changed)

func _on_pause_state_changed(is_paused: bool):
	visible = is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause") and multiplayer.is_server(): 
		GameManager.request_toggle_pause.rpc_id(1)
