extends Control

const DEFAULT_IP = '127.0.0.1'
const PORT = 8910

func _on_server_button_down():
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	_start_game()

func _on_client_button_down():
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP, PORT)
	multiplayer.multiplayer_peer = peer
	
	_start_game()

func _start_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
