extends Control

@onready var text_edit: TextEdit = $TextEdit

func _on_server_button_down() -> void:
	Lobby.is_server = true
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_client_button_down() -> void:
	Lobby.is_server = false
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _changed_ip() -> void:
	Lobby.server_ip = text_edit.text
