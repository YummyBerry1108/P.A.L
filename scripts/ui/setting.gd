extends Control

func _ready() -> void:
	hide()

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_button_pressed() -> void:
	visible = not visible

func _on_volume_value_changed(value: float) -> void:
	pass # Replace with function body.

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"):
		visible = not visible
