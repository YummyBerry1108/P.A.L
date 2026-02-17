extends Control

@onready var player_list: Label = $PlayerList

func _ready() -> void:
	Lobby.player_connected.connect(player_list._on_lobby_player_connected)
	Lobby.player_disconnected.connect(player_list._on_lobby_plater_disconnected)
	Lobby.server_disconnected.connect(_leave_lobby)

	if multiplayer.multiplayer_peer.get_class() != "OfflineMultiplayerPeer":
		return
	if Lobby.is_server:
		Lobby.create_game()
	else:
		Lobby.join_game()
		
func _start_game() -> void:
	if not multiplayer.is_server():
		return
	Lobby.load_game.rpc("res://scenes/main.tscn")

func _leave_lobby() -> void:
	Lobby.remove_multiplayer_peer()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
