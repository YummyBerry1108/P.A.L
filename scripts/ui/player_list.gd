extends Label

var player_list: Dictionary = {}

func _ready() -> void:
	text =\
	"""
	Player List
	----------------
	"""
	player_list = Lobby.players
	_change_label()
	#text = Lobby.players 

func _on_lobby_player_connected(peer_id: int, player_info: Dictionary) -> void:
	player_list[peer_id] = player_info
	
	_change_label()
	
func _on_lobby_plater_disconnected(peer_id: int) -> void:
	player_list.erase(peer_id)
	_change_label()
	
func _change_label() -> void:
	text = \
	"""
	Player List
	----------------
	"""
	var player_keys: Array = player_list.keys()
	player_keys.sort()
	for player_id in player_keys:
		text += str(player_id) + "\n"
