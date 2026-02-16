extends Label

var player_list: Dictionary = {}

func _ready() -> void:
	text =\
	"""
	Player List
	----------------
	"""
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
	
	for player_id in player_list:
		text += str(player_id) + "\n"
