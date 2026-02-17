extends Control

@onready var ip: LineEdit = $IP
@onready var username: LineEdit = $Username

func _on_server_button_down() -> void:
	Lobby.is_server = true
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_client_button_down() -> void:
	Lobby.is_server = false
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _changed_ip(new_text: String) -> void:
	Lobby.server_ip = new_text

func _changed_username(new_text: String) -> void:
	Lobby.player_username = new_text
	
