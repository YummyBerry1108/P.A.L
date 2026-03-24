extends TextureRect
@export var player_info_container: VBoxContainer

var player_nodes: Array[Player]
var player_to_label: Dictionary[Player, Label]
var player_ready: bool = false

func _ready() -> void:
	Lobby.all_player_ready.connect(_on_all_player_ready)
	for label in player_info_container.get_children():
		label.text = ""

func _process(delta: float) -> void:
	if not ready: return
	for player: Player in player_nodes:
		if not player: continue
		var label: Label = player_to_label[player]
		label.text = \
		player.username + \
		": " + \
		str(int(player.player_stat.hp)) + \
		" / " + \
		str(int(player.player_stat.max_hp))

func _on_all_player_ready() -> void:
	var players = get_tree().get_nodes_in_group("players")
	var labels = player_info_container.get_children()
	
	player_ready = true
	
	for player in players:
		if player.name == str(multiplayer.get_unique_id()): continue
		player_nodes.append(player)
	for idx in range(player_nodes.size()):
		player_to_label[player_nodes[idx]] = labels[idx]
