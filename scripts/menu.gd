extends Control


func _on_server_button_down():
	Lobby.is_server = true
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_client_button_down():
	Lobby.is_server = false
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
